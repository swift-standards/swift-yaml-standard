// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-yaml-standard",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(name: "YAML Standard", targets: ["YAML Standard"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-graph-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-lexer-primitives.git",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "YAML Standard",
            dependencies: [
                .product(name: "Graph Sequential Primitives", package: "swift-graph-primitives"),
                .product(name: "Lexer Primitives", package: "swift-lexer-primitives")
            ],
            path: "Sources/YAML Standard"
        ),
        .testTarget(
            name: "YAML Standard Tests",
            dependencies: [.target(name: "YAML Standard")],
            path: "Tests/YAML Standard Tests"
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .strictMemorySafety(),
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
            .enableExperimentalFeature("SuppressedAssociatedTypes"),
            .enableUpcomingFeature("InferIsolatedConformances")
        ]
}
