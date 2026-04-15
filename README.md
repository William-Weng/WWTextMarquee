# WWTextMarquee
[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-16.0](https://img.shields.io/badge/iOS-16.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![TAG](https://img.shields.io/github/v/tag/William-Weng/WWTextMarquee) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

## 🎉 [相關說明](https://developer.apple.com/documentation/coretext/ctline)

> `WWTextMarquee` is a lightweight Swift-based library that renders **LED-style scrolling text (marquee)** on iOS.  
It uses [WWTextRasterizer](https://github.com/William-Weng/WWTextRasterizer) to convert text into LED dot-matrix images, and animates them smoothly with `CADisplayLink`.
>
> Perfect for creating dynamic banners, electronic signs, or simulating LED displays.

> `WWTextMarquee` 是一個可在 iOS 上顯示 **LED 文字跑馬燈效果** 的套件，採用 [WWTextRasterizer](https://github.com/William-Weng/WWTextRasterizer) 將文字轉換為 LED 點陣影像，並透過 `CADisplayLink` 控制動畫更新。
>
> 它非常適合用於展示動態標語、電子看板、或模擬 LED 顯示螢幕。

## 🧩 [效果示意](https://peterpanswift.github.io/iphone-bezels/)

![](https://github.com/user-attachments/assets/903dbd3f-9b03-4404-9543-6b31b8a2b518)

https://github.com/user-attachments/assets/0e6b86f6-9e95-485f-9171-a3757b67e092

## ✨ [特點](https://swiftpackageindex.com/William-Weng)

- 將文字轉換為 LED 點陣畫面。  
- 支援平滑跑馬燈動畫，速度可自訂。  
- 可調整 LED 顏色、背景、點型、間距等參數。  
- 與 `WWTextRasterizer` 完美整合。

## 📦 [安裝方式](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)

使用 **Swift Package Manager (SPM)**：

```swift
dependencies: [
    .package(url: "https://github.com/William-Weng/WWTextMarquee.git", from: "1.0.2")
]
```

## ⚙️ 內部屬性

| 屬性 | 類型 | 說明 |
|------|------|------|
| `ledColor` | `LEDColorSetting` | LED 顏色設定（亮燈、暗燈、背景） |
| `dot` | `DotSetting` | 點大小、間距與形狀設定 |
| `speed` | `CGFloat` | 跑馬燈速度（像素/秒） |
| `currentOffsetX` | `CGFloat` | 畫面目前的水平偏移量 |

## 🧲 內部方法

以下函式為內部使用，一般情況下不需直接呼叫：

| 函式名稱 | 說明 |
|-----------|------|
| `initPanel(_:)` | 初始化LED背景，可以調整需要的寬度大小。 |
| `start(text:verticalAlignment:)` | 建立並啟用 `CADisplayLink`，開始畫面更新。 |
| `stop()` | 使 `CADisplayLink` 失效並重設時間參數。 |
| `removeFromSuperview()` | 停止畫面更新，並且移除跑馬燈。 |
| `setOrigin(_:)` | 設定面板位置。 |
| `setCenter(_:)` | 設定面板中心。 |

## 🔍 運作原理

`WWTextMarquee` 內部透過 `CADisplayLink` 驅動畫面更新：

- 每次畫面更新時計算時間差 (`deltaTime`)。  
- 根據速度 (`speed`) 移動文字位置。  
- 當文字完全離開畫面時，重設偏移量以產生循環效果。

## 🚀 使用範例

```swift
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
```
