# ``LoggingOSLog``

An unified logging backend implementation for SwiftLog.

## Overview

LoggingOSLog is a logging backend implementation for [SwiftLog][swift-log], that
routes log messages to [OSLog][oslog], the
[unified logging system][unified-logging] on Apple platforms. On macOS you can
view the log messages using the Console app or the `log` cli tool.

While SwiftLog is available on all Swift platforms though, the
unified logging system of OSLog is only available on Apple platforms.
Use this library to combine both worlds. Use SwiftLog in your codebase and use
this library as the backend implementation when compiling for an Apple platform,
i.e. using `#if canImport(Darwin)`.

[unified-logging]: https://developer.apple.com/documentation/os/logging
[oslog]: https://developer.apple.com/documentation/oslog
[backend]: https://swiftpackageindex.com/apple/swift-log/1.10.1/documentation/logging
[swift-log]: https://github.com/apple/swift-log

## Getting started

Use this package if you're writing a cross-platform (for example, Linux and
macOS) application or library and still want to take full advantage of the
unified logging system on Apple platforms.

### Adding the Dependency

Add the dependency to your Package.swift:

```swift
.package(url: "https://github.com/astzweig/swift-log-oslog", from: "1.0.0")
```

And to your target:

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

## Relation to the unified logging system

The [unified logging system][unified-logging] uses two parameters to allow for
better filtering of log messages: [subsystem][subsystem] and
[category][category]. [SwiftLog][swift-log] has only a label parameter, so this
library maps a reverse domain style label to the subsystem and category
parameters of the unified logging system. See
``/LoggingOSLog/LoggingOSLog/init(label:)`` for more information.

[subsystem]: https://developer.apple.com/documentation/os/generating-log-messages-from-your-code#:~:text=The%20subsystem%20string,for%20each%20subsystem%20string.
[category]: https://developer.apple.com/documentation/os/generating-log-messages-from-your-code#:~:text=The%20category%20string,for%20these%20strings.

## Topics

### API

- ``LoggingOSLog``
