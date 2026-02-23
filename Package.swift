// swift-tools-version: 6.2

import PackageDescription

let package: Package = Package(name: "PFunc", platforms: [
        .macOS(.v26),
        .visionOS(.v26),
        .iOS(.v26)
    ], products: [
        .library(name: "PFunc", targets: [
            "PFunc"
        ])
    ], targets: [
        .target(name: "PFunc"),
        .testTarget(name: "PFuncTests", dependencies: [
            "PFunc"
        ])
    ])
