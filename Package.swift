// swift-tools-version: 5.9

import PackageDescription

let version = "0.1.2"

let package = Package(
    name: "CodeMeasureKit",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_14),
        .macCatalyst(.v14),
        .tvOS(.v14),
        .watchOS(.v4),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "CodeMeasureKit", targets: ["CodeMeasureKit"]),
    ],
    targets: [
        .target(name: "CodeMeasureKit"),
    ]
)
