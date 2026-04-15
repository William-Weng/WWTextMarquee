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
        
        let marquee: WWTextMarquee = .init(config: config)
        
        marquee.initPanel(in: view, columns: 128, rows: 64)
        marquee.setCenter(view.center)
        marquee.start(text: text)

        self.textMarquee = marquee
    }
}

