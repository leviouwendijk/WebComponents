// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WebComponentsTests",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "webctest",
            targets: [
                "WebComponentsTestFlows"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/leviouwendijk/CSS.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/JS.git", branch: "master"),

        .package(url: "https://github.com/leviouwendijk/Constructors.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Assets.git", branch: "master"),

        // .package(url: "https://github.com/leviouwendijk/Milieu.git", branch: "master"),
        // .package(url: "https://github.com/leviouwendijk/Writers.git", branch: "master"),
        // .package(url: "https://github.com/leviouwendijk/Version.git", branch: "master"),
        // .package(url: "https://github.com/leviouwendijk/Path.git", branch: "master"),
        // .package(url: "https://github.com/leviouwendijk/ProtocolComponents.git", branch: "master"),

        .package(
            url: "https://github.com/leviouwendijk/TestFlows.git",
            branch: "master"
        ),
        .package(path: ".."),
    ],
    targets: [
        .executableTarget(
            name: "WebComponentsTestFlows",
            dependencies: [
                .product(name: "WebComponents", package: "WebComponents"),
                .product(
                    name: "Constructors",
                    package: "Constructors"
                ),
                .product(
                    name: "CSS",
                    package: "CSS"
                ),
                .product(
                    name: "JS",
                    package: "JS"
                ),
                .product(
                    name: "Assets",
                    package: "Assets"
                ),
                .product(
                    name: "TestFlows",
                    package: "TestFlows"
                ),
            ]
        ),
    ]
)
