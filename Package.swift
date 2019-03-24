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
        .package(url:"https://github.com/enums/Pjango.git" , from: "2.1.0"),
        .package(url:"https://github.com/enums/Pjango-MySQL.git" , from: "2.1.0"),
        .package(url:"https://github.com/enums/Pjango-Postman.git" , from: "2.1.0"),
        ],
    targets: [
        .target(
            name: "Calatrava",
            dependencies: [
                "Pjango",
                "PjangoMySQL",
                "PjangoPostman",
            ])
    ]
)
