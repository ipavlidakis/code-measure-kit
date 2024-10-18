// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "1.0.0"

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
        .library(
            name: "CodeMeasureKit",
            targets: ["CodeMeasureKit"]),
    ],
    targets: [
        .target(
            name: "CodeMeasureKit"),

    ]
)
