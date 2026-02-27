# SwiftLog OSLog
A OSLog ([unified logging][unfied-logging]) [backend implementation][backend] for [SwiftLog (swift-log)][swift-log].
It maps the `label` parameter of [SwiftLog (swift-log) to the `subsystem` and
`category` parameter of `OSLog`. It even allows the use of the bundle
identifier - if any  as a value for the `subsystem` parameter.

[unified-logging]: https://developer.apple.com/documentation/os/logging
[backend]: https://swiftpackageindex.com/apple/swift-log/1.10.1/documentation/logging
[swift-log]: https://github.com/apple/swift-log

## Installation
To use this library in your project, add it to the package dependencies:

```swift
.package(url: "https://github.com/astzweig/swift-log-oslog", from: "1.0.0")
```

and add it as a dependency on the specific target:

```swift
.target(
	name: "YourTarget",
	dependencies: [
		.product(name: "LoggingOSLog", package: "swift-log-oslog")
	]
)
```

### Basic Usage
```swift
// Import the logging API and this backend implementation
import Logging
#if canImport(Darwin)
import LoggingOSLog
#endif

// Later, in your application initialization code
func init() {
	// ...
	#if canImport(Darwin)
	LoggingSystem.bootstrap(LoggingOSLog.init)
	#endif
	
	// Start creating loggers
	let loggers: [String: Logger] = [
		"main": Logger(label: "com.example.yourapp.Main"),
		"mail": Logger(label: "com.example.yourapp.Mail System"),
	]
}
```