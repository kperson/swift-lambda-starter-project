---
to: Package.swift
unless_exists: true
sh: swift package generate-xcodeproj && swift test --generate-linuxmain
---
// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "<%=locals.name%>",
    products: [
        .library(name: "<%=h.capitalize(locals.name)%>", targets: ["<%=h.capitalize(locals.name)%>"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-aws/aws-sdk-swift.git", .upToNextMinor(from: "3.1.0")),
        .package(url: "https://github.com/kperson/swift-lambda-tools.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "<%=h.capitalize(locals.name)%>",
            dependencies: [
                "SwiftAWS",
                "DynamoDB"
            ],
            path: "./Sources"
        ),
        .testTarget(
            name: "<%=h.capitalize(locals.name)%>Tests",
            dependencies: [
                "<%=h.capitalize(locals.name)%>"
            ],
            path: "./Tests"
        )
    ]
)
