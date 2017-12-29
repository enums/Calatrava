import PackageDescription

let package = Package(
    name: "Calatrava",
    targets: [
        Target(name: "Calatrava", dependencies:[]),
    ],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 3, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion: 3, minor: 0),
        .Package(url: "https://github.com/enums/Pjango.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/enums/Pjango-MySQL.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/enums/SwiftyJSON.git", majorVersion: 4),
    ]
)
