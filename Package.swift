// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleGolfIndicator",
    platforms: [
        .watchOS(.v10),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SimpleGolfIndicator",
            targets: ["SimpleGolfIndicator"]),
    ],
    dependencies: [
        // Dependencies go here
    ],
    targets: [
        .target(
            name: "SimpleGolfIndicator",
            dependencies: []),
        .testTarget(
            name: "SimpleGolfIndicatorTests",
            dependencies: ["SimpleGolfIndicator"]),
    ]
)
