// swift-tools-version: 6.0

import PackageDescription

let package: Package = Package(name: "p-func", platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .visionOS(.v2)
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
