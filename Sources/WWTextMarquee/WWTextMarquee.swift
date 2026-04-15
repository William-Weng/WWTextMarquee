//
//  WWTextMarquee.swift
//  WWTextMarquee
//
//  Created by William.Weng on 2026/4/14.
//

import UIKit
import WWTextRasterizer

// MARK: - 文字跑馬燈
public final class WWTextMarquee {
    
    public var ledColor: LEDColorSetting = (on: .yellow, off: .yellow.withAlphaComponent(0.12), background: .black)
    public var dot: DotSetting = (size: 4, spacing: 3, type: .square(0.22))
    public var speed: CGFloat = 120
    
    public private(set) var currentOffsetX: CGFloat = 0
    
    private let containerView = UIView()
    private let baseImageView = UIImageView()
    private let textImageView = UIImageView()
    private let rasterizer: WWTextRasterizer
    
    private var displayLink: CADisplayLink?
    private var previousTimestamp: CFTimeInterval = 0
    
    public init(config: Configuration) {
        rasterizer = .init(config: config)
    }
    
    deinit {
        removeFromSuperview()
    }
}

// MARK: - 公開函式
public extension WWTextMarquee {
    
    /// 初始化LED背景
    /// - Parameters:
    ///   - view: 顯示在哪裡
    ///   - columns: LED數量寬
    ///   - rows: LED數量高
    func initPanel(in view: UIView, columns: Int, rows: Int = 64) {
        
        let baseImage = WWTextRasterizer.renderLEDMatrixBase(columns: columns, rows: rows, ledColor: ledColor.off, backgroundColor: ledColor.background, dot: dot, scale: 1, opaque: true)
        
        containerView.frame = CGRect(origin: .zero, size: baseImage.size)
        containerView.clipsToBounds = true
        
        baseImageView.frame = containerView.bounds
        baseImageView.image = baseImage
        
        if (containerView.superview !== view) { containerView.removeFromSuperview(); view.addSubview(containerView) }
        if (baseImageView.superview !== containerView) { containerView.addSubview(baseImageView) }
    }
        
    /// 開始執行
    /// - Parameters:
    ///   - text: 欲轉換的文字
    ///   - verticalAlignment: 文字顯示位置 - 上 / 中 / 下
    func start(text: String, verticalAlignment: VerticalAlignmentMode = .center()) {
        
        let result = rasterizer.convert(text)
        let textImage = result.matrix.renderLEDMatrixText(columns: result.matrix.width, rows: result.matrix.height, offsetX: 0, ledColor: ledColor.on, dot: dot)
        let originY = verticalAlignment.originY(in: containerView.bounds, textHeight: textImage.size.height)
        
        stopMarquee()
        
        currentOffsetX = containerView.bounds.width
        
        textImageView.removeFromSuperview()
        textImageView.image = textImage
        textImageView.frame = CGRect(x: currentOffsetX, y: originY, width: textImage.size.width, height: textImage.size.height)
        
        containerView.addSubview(textImageView)
        
        startMarquee()
    }
    
    /// 停止執行
    func stop() {
        stopMarquee()
    }
    
    /// 移除跑馬燈
    func removeFromSuperview() {
        stopMarquee()
        textImageView.removeFromSuperview()
        baseImageView.removeFromSuperview()
        containerView.removeFromSuperview()
    }
    
    /// 設定面板位置
    /// - Parameter origin: CGPoint
    func setOrigin(_ origin: CGPoint) {
        containerView.frame.origin = origin
    }
    
    /// 設定面板中心
    /// - Parameter center: CGPoint
    func setCenter(_ center: CGPoint) {
        containerView.center = center
    }
}

// MARK: - @objc
private extension WWTextMarquee {
    
    /// 更新跑馬燈 (定時功能)
    @objc func updateMarquee(_ link: CADisplayLink) {
        
        guard (previousTimestamp != 0) else { previousTimestamp = link.timestamp; return }
        
        let delta = link.timestamp - previousTimestamp
        previousTimestamp = link.timestamp
        
        currentOffsetX -= speed * delta
        textImageView.frame.origin.x = currentOffsetX
        
        if (textImageView.frame.maxX < 0) {
            currentOffsetX = containerView.bounds.width
            textImageView.frame.origin.x = currentOffsetX
        }
    }
}

// MARK: - 小工具
private extension WWTextMarquee {
    
    /// 啟動定時器
    func startMarquee() {
        
        stopMarquee()
        
        let link = CADisplayLink(target: self, selector: #selector(updateMarquee(_:)))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }
    
    /// 停止定時器
    func stopMarquee() {
        displayLink?.invalidate()
        displayLink = nil
        previousTimestamp = 0
    }
}
