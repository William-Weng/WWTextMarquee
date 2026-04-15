//
//  Constant.swift
//  WWTextMarquee
//
//  Created by William.Weng on 2026/4/14.
//

import UIKit
import WWTextRasterizer

// MARK: - typealias
public extension WWTextMarquee {
    
    typealias Configuration = WWTextRasterizer.Configuration
    typealias LEDColorSetting = WWTextRasterizer.LEDColorSetting
    typealias DotSetting = WWTextRasterizer.DotSetting
}

// MARK: - enum
public extension WWTextMarquee {
    
    /// 垂直對準類型 - 上 / 中 / 下
    enum VerticalAlignmentMode {
        
        case top(_ offset: CGFloat = 0)
        case center(_ offset: CGFloat = 0)
        case bottom(_ offset: CGFloat = 0)
        
        /// 計算出校準後的值
        /// - Parameters:
        ///   - frame: CGRect
        ///   - textHeight: 文字高度
        /// - Returns: CGFloat
        func originY(in frame: CGRect, textHeight: CGFloat) -> CGFloat {
            switch self {
            case .top(let offset): return offset
            case .center(let offset): return (frame.height - textHeight) * 0.5 + offset
            case .bottom(let offset): return frame.height - textHeight + offset
            }
        }
    }
}
