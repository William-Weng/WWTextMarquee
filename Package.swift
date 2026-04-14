// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWTextMarquee",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "WWTextMarquee", targets: ["WWTextMarquee"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWTextRasterizer", .upToNextMinor(from: "1.2.0"))
    ],
    targets: [
        .target(name: "WWTextMarquee", dependencies: ["WWTextRasterizer"], resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
