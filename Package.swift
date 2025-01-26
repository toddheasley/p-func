// swift-tools-version: 6.0

import PackageDescription

let package: Package = Package(name: "powered-up", platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
        .tvOS(.v18)
    ], products: [
        .library(name: "PoweredUp", targets: [
            "PoweredUp"
        ])
    ], targets: [
        .target(name: "PoweredUp"),
        .testTarget(name: "PoweredUpTests", dependencies: [
            "PoweredUp"
        ])
    ])
