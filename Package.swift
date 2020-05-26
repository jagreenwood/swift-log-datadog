// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-log-data-dog",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DataDogLog",
            targets: ["DataDogLog"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "DataDogLog",
            dependencies: [.product(name: "Logging", package: "swift-log")]),
        .testTarget(
            name: "DataDogLogTests",
            dependencies: ["DataDogLog"]),
    ]
)
