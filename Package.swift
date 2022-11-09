// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCWebRTC",
    platforms: [ .macOS(.v10_14), .iOS(.v12) ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "XCWebRTC",
            targets: ["WebRTC"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/TechTeamer/ios-xc-webrtc/raw/master/XCWebRTC/1.0.2/WebRTC.xcframework.zip",
            checksum: "47c19b44f38a1aa2b870d7b33b30b684a6aae7f7a9271a0e1f7b52f598105f98")
    ]
)
