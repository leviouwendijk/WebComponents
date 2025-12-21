// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WebComponents",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WebComponents",
            targets: ["WebComponents"]
        ),
    ],
    dependencies: [
        // .package(url: "https://github.com/leviouwendijk/Primitives.git", branch: "master"),
        // .package(url: "https://github.com/leviouwendijk/Methods.git", branch: "master"),
        // .package(url: "https://github.com/leviouwendijk/Milieu.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/HTML.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/CSS.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/JS.git", branch: "master"),

        .package(url: "https://github.com/leviouwendijk/Constructors.git", branch: "master"),

        // .package(url: "https://github.com/leviouwendijk/Milieu.git", branch: "master"),
        // .package(url: "https://github.com/leviouwendijk/Writers.git", branch: "master"),
        // .package(url: "https://github.com/leviouwendijk/Version.git", branch: "master"),
        // .package(url: "https://github.com/leviouwendijk/Path.git", branch: "master"),
        // .package(url: "https://github.com/leviouwendijk/ProtocolComponents.git", branch: "master"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WebComponents",
            dependencies: [
                // .product(name: "Primitives", package: "Primitives"),
                // .product(name: "Methods", package: "Methods"),
                // .product(name: "Milieu", package: "Milieu"),
                .product(name: "HTML", package: "HTML"),
                .product(name: "CSS", package: "CSS"),
                .product(name: "JS", package: "JS"),

                .product(name: "Constructors", package: "Constructors"),

                // .product(name: "Milieu", package: "Milieu"),
                // .product(name: "Writers", package: "Writers"),
                // .product(name: "Version", package: "Version"),
                // .product(name: "Path", package: "Path"),
                // .product(name: "ProtocolComponents", package: "ProtocolComponents"),
            ],
        ),
        .testTarget(
            name: "WebComponentsTests",
            dependencies: ["WebComponents"]
        ),
    ]
)
