// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ApnsPublisher",
    dependencies: [
        .package(url:"https://github.com/mono0926/vapor-apns.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "ApnsPublisher",
            dependencies: [
                "VaporAPNS"
            ]),
    ]
)
