// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DygmaFocusAPI",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "DygmaFocusAPI",
            targets: ["DygmaFocusAPI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/armadsen/ORSSerialPort.git", from: "2.1.0"),
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.3.1")
    ],
    targets: [
        .target(
            name: "DygmaFocusAPI",
            dependencies: [
                .product(name: "Factory", package: "factory"),
                .product(name: "ORSSerial", package: "orsserialport")
            ]
        ),
        .testTarget(
            name: "DygmaFocusAPITests",
            dependencies: ["DygmaFocusAPI"]
        )
    ]
)
