// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YoudaoTranslatorX",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.1"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0")),
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", .upToNextMajor(from: "4.2.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "YoudaoTranslatorX",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser"),
                           .product(name: "Alamofire", package: "Alamofire"),
                           .product(name: "ObjectMapper", package: "ObjectMapper")]),
        .testTarget(
            name: "YoudaoTranslatorXTests",
            dependencies: ["YoudaoTranslatorX"]),
    ]
)
