//
//  WWTextMarquee.swift
//  WWTextMarquee
//
//  Created by William.Weng on 2026/4/14.
//

import UIKit
import WWTextRasterizer

// MARK: - 文字跑馬燈
public class WWTextMarquee {
    
    public typealias Configuration = WWTextRasterizer.Configuration
    public typealias LEDColorSetting = WWTextRasterizer.LEDColorSetting
    public typealias DotSetting = WWTextRasterizer.DotSetting
    
    public var ledColor: LEDColorSetting = (on: .red, off: .red.withAlphaComponent(0.12), background: .black)
    public var dot: DotSetting = (size: 4, spacing: 3, type: .square(0.22))
    public var speed: CGFloat = 120
    public var currentOffsetX: CGFloat = 0
    
    private let containerView = UIView()
    private let baseImageView = UIImageView()
    private let textImageView = UIImageView()
    private let rasterizer: WWTextRasterizer
    
    private var displayLink: CADisplayLink?
    private var previousTimestamp: CFTimeInterval = 0
    private var accumulator: CFTimeInterval = 0
    
    public init(config: Configuration) {
        rasterizer = .init(config: config)
    }
    
    deinit {
        stopMarquee()
    }
}

// MARK: - 公開函式
public extension WWTextMarquee {
    
    /// 初始化LED背景
    /// - Parameters:
    ///   - view: 顯示在哪裡
    ///   - columns: LED數量寬
    func initPanel(in view: UIView, columns: Int) {

        let baseImage = WWTextRasterizer.renderLEDMatrixBase(columns: columns, rows: 64, ledColor: ledColor.off, backgroundColor: ledColor.background, dot: dot, scale: 1, opaque: true)
        
        containerView.frame = CGRect(origin: .zero, size: baseImage.size)
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        
        baseImageView.frame = containerView.bounds
        baseImageView.image = baseImage
        containerView.addSubview(baseImageView)
    }
    
    /// 開始執行
    /// - Parameters:
    ///   - text: 欲轉換的文字
    ///   - offsetY: 上下位置修正
    func start(text: String, offsetY: CGFloat) {
        
        let result = rasterizer.convert(text)
        let panelRows = result.matrix.height
        let textImage = result.matrix.renderLEDMatrixText(columns: result.matrix.width, rows: result.matrix.height, offsetX: 0, ledColor: ledColor.on, dot: dot)
        
        textImageView.image = textImage
        textImageView.frame = CGRect(x: containerView.bounds.width, y: offsetY, width: textImage.size.width, height: textImage.size.height)
        containerView.addSubview(textImageView)
        
        startMarquee()
    }
    
    /// 停止執行
    func stop() {
        stopMarquee()
    }
}

// MARK: - @objc
private extension WWTextMarquee {
    
    /// 更新跑馬燈
    /// - Parameter link: CADisplayLink
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
