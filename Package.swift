import PackageDescription

let package = Package(
    name: "Calatrava",
    targets: [
        Target(name: "Calatrava", dependencies:[]),
    ],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/enums/Pjango.git", majorVersion: 0, minor: 9),
        .Package(url: "https://github.com/enums/SwiftyJSON.git", majorVersion: 4),
    ]
)
