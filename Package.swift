// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DylibLoginKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "DylibLoginKit", type: .dynamic, targets: ["DylibLoginKit"])
    ],
    targets: [
        .target(name: "DylibLoginKit"),
        .testTarget(name: "DylibLoginKitTests", dependencies: ["DylibLoginKit"])
    ]
)
