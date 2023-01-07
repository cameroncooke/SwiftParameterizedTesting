// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ParameterizedTesting",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "ParameterizedTesting",
            targets: ["ParameterizedTesting"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.10.0"),
    ],
    targets: [
        .target(
            name: "ParameterizedTesting",
            dependencies: []
        ),
        .testTarget(
            name: "ExampleTests",
            dependencies: [
                "ParameterizedTesting",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            exclude: ["__Snapshots__"]
        ),
        .testTarget(
            name: "ParameterizedTestingTests",
            dependencies: [
                "ParameterizedTesting",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            exclude: ["__Snapshots__"]
        ),
    ]
)
