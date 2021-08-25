// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GECalendar",
    platforms: [
        .macOS(.v11), .iOS(.v14)
    ],
    products: [
        .library(
            name: "GECalendar",
            targets: ["GECalendar"]),
    ],
    targets: [
        .target(
            name: "GECalendar",
            dependencies: []),
        .testTarget(
            name: "GECalendarTests",
            dependencies: ["GECalendar"]),
    ]
)
