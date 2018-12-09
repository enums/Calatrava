// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Calatrava",
    products: [
        .executable(
            name: "Calatrava",
            targets: ["Calatrava"]),
        ],
    dependencies: [
        .package(url:"https://github.com/PerfectlySoft/Perfect-HTTPServer.git" , from: "3.0.19"),
        .package(url:"https://github.com/PerfectlySoft/Perfect-Mustache.git" , from: "3.0.2"),
        .package(url:"https://github.com/PerfectlySoft/Perfect-CURL.git" , from: "3.1.0"),
        .package(url:"https://github.com/PerfectlySoft/Perfect-Crypto.git" , from: "3.1.2"),
        .package(url:"https://github.com/enums/Pjango.git" , from: "2.0.0"),
        .package(url:"https://github.com/enums/Pjango-MySQL.git" , from: "2.0.0"),
        .package(url:"https://github.com/enums/Pjango-Postman.git" , from: "2.0.0"),
        .package(url:"https://github.com/enums/Pjango-SwiftyJSON.git" , from: "1.0.0"),
        ],
    targets: [
        .target(
            name: "Calatrava",
            dependencies: ["PerfectHTTPServer", "PerfectMustache", "PerfectCURL", "PerfectCrypto", "Pjango", "PjangoMySQL", "PjangoPostman", "SwiftyJSON"])
    ]
)
