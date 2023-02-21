// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Kaleidoscope",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v15)
    ],
    products: [
        .library(name: "Kaleidoscope", targets: ["Kaleidoscope"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.7.0"),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "0.3.0"),
    ],
    targets: [
        .target(
            name: "KaleidoscopeLib",
            dependencies: [.product(name: "Parsing", package: "swift-parsing")]
        ),
        .target(
            name: "Kaleidoscope",
            dependencies: ["KaleidoscopeLib"]
        ),
        .testTarget(
            name: "KaleidoscopeLibTests",
            dependencies: [
                "KaleidoscopeLib",
                .product(name: "CustomDump", package: "swift-custom-dump")
            ]
        ),
    ]
)
