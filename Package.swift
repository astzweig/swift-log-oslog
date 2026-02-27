// swift-tools-version: 6.0
import PackageDescription

let package = Package(
	name: "swift-log-oslog",
	platforms: [.macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v6)],
	products: [
		.library(
			name: "LoggingOSLog",
			targets: ["LoggingOSLog"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-log", from: "1.10.1"),
	],
	targets: [
		.target(
			name: "LoggingOSLog",
			dependencies: [.product(name: "Logging", package: "swift-log")],
			path: "Sources/Logging OSLog"
		),
		.testTarget(
			name: "LoggingOSLogTests",
			dependencies: [
				.product(name: "Logging", package: "swift-log"),
				"LoggingOSLog"
			],
			path: "Tests/Logging OSLog Tests",
		),
	]
)
