// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "swift-log-datadog",
    platforms: [
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "DataDogLog",
            targets: ["DataDogLog"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),
    ],
    targets: [
        .target(
            name: "DataDogLog",
            dependencies: [.product(name: "Logging", package: "swift-log")]),
        .testTarget(
            name: "DataDogLogTests",
            dependencies: ["DataDogLog"]),
    ],
    swiftLanguageVersions: [.version("6"), .v5]
)

#if os(Linux)
package.dependencies.append(.package(url: "https://github.com/swift-server/async-http-client.git", from: "1.19.0"))
package.targets.first { $0.name == "DataDogLog" }?.dependencies.append(.product(name: "AsyncHTTPClient", package: "async-http-client"))
#endif
