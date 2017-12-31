// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Calatrava",
    products: [
        .executable(name: "Calatrava", targets: ["Calatrava"])
    ],
    dependencies: [
        .package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.3"),
        .package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", from: "3.0.1"),
        .package(url: "https://github.com/enums/Pjango.git", from: "1.1.0"),
        .package(url: "https://github.com/enums/Pjango-MySQL.git", from: "1.2.0"),
        .package(url: "https://github.com/enums/SwiftyJSON.git", from: "4.0.0"),
    ],
    targets: [
        .target(name: "Calatrava", dependencies: ["PerfectHTTPServer", "PerfectMustache", "Pjango", "Pjango-MySQL", "SwiftyJSON"]),
    ]
)
