import PackageDescription

#if os(OSX)
let package = Package(
    name: "Calatrava",
    targets: [
        Target(name: "Calatrava", dependencies:[]),
        ],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 3, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion: 3, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 3, minor: 0),
        .Package(url: "https://github.com/enums/Pjango.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/enums/Pjango-MySQL.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/enums/Pjango-Postman.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/enums/SwiftyJSON.git", majorVersion: 4),
        ]
)
#else
let package = Package(
    name: "Calatrava",
    targets: [
        Target(name: "Calatrava", dependencies:[]),
        ],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Crypto.git", majorVersion: 1, minor: 0),
        .Package(url: "https://github.com/enums/Pjango.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/enums/Pjango-MySQL.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/enums/Pjango-Postman.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/enums/SwiftyJSON.git", majorVersion: 4),
        ]
)
#endif


