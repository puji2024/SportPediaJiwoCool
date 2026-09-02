// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SportsPediaModules",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "SportsPediaCommon", targets: ["SportsPediaCommon"]),
        .library(name: "SportsPediaDomain", targets: ["SportsPediaDomain"]),
        .library(name: "SportsPediaData", targets: ["SportsPediaData"])
    ],
    targets: [
        .target(name: "SportsPediaCommon"),
        .target(name: "SportsPediaDomain"),
        .target(
            name: "SportsPediaData",
            dependencies: ["SportsPediaCommon", "SportsPediaDomain"]
        ),
        .testTarget(
            name: "SportsPediaDataTests",
            dependencies: ["SportsPediaCommon", "SportsPediaData"]
        )
    ]
)
