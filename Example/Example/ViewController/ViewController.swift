//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/10/29.
//

import UIKit
import WWTextMarquee

final class ViewController: UIViewController {
    
    private let text = "Hello, こんにちは, 안녕하세요, 哈囉"
    private var textMarquee: WWTextMarquee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WWTextMarquee.Configuration(
            font: .systemFont(ofSize: 16),
            targetHeight: 36,
            threshold: 110,
            horizontalPadding: 5,
            trimHorizontalEmptySpace: true,
            characterGap: 2
        )
        
        textMarquee = .init(config: config)
        textMarquee?.initPanel(in: view, columns: 128)
        textMarquee?.start(text: text, offsetY: 60)
    }
}

