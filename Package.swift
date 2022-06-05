// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DAF",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DAF",
            targets: ["DAF"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-system.git", from: "1.1.1"),
        .package(name: "swift-bytes", path: "../swift-bytes"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DAF",
            dependencies: [
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "Bytes", package: "swift-bytes"),
                .product(name: "BytesFoundationCompatibility", package: "swift-bytes"),
            ]),
        .testTarget(
            name: "DAFTests",
            dependencies: ["DAF"]),
    ]
)
