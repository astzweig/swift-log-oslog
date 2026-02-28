import Foundation
import os
import Logging

public struct LoggingOSLog: LogHandler {
	public var logLevel: Logging.Logger.Level = .info
	public var metadata: Logging.Logger.Metadata = [:]
	public var metadataProvider: Logging.Logger.MetadataProvider?
	private let oslogger: os.Logger

	/**
		Initializer that may be passed directly to 
		[LoggingSystem.bootstrap](https://swiftpackageindex.com/apple/swift-log/1.10.1/documentation/logging/loggingsystem/bootstrap(_:)).

		- Parameter label: Example: com.example.sometool.MailProcessing
						   A reverse domain style identifier. The part up until the
						   last dot is used as the subsystem and the part after the
						   last dot is used as the category of the unified logging
						   message.
						   After the last dot spaces may be used to separate words.
						   If you want to use the application bundle identifier as the
						   subsystem, use a value without any dot and the whole value
						   will be mapped as the category of the unified logging system and
						   the subsystem is either the bundle identifier - if any - or
						   the string "SwiftLogToOsLog".
	 */
	public init(label: String) {
		let lastDotPosition = label.lastIndex(of: ".") ?? label.startIndex
		let frontPart = label.prefix(upTo: lastDotPosition)
		let backPart = label.suffix(from: lastDotPosition)
		guard frontPart.count > 0 else {
			let subsystem = Bundle.main.bundleIdentifier ?? "SwiftLogToOsLog"
			self.init(subsystem: subsystem, category: label)
			return
		}
		self.init(subsystem: String(frontPart), category: String(backPart))
	}

	/**
		This Initializer may not be passed directly to
		[LoggingSystem.bootstrap](https://swiftpackageindex.com/apple/swift-log/1.10.1/documentation/logging/loggingsystem/bootstrap(_:)).
		It must be wrapped beforehand, but allows for direct assignment of subsystem and
		category parameters of [OSLog](https://developer.apple.com/documentation/oslog).

		- Parameters:
			- subsystem: See the [Apple documentation](https://developer.apple.com/documentation/os/generating-log-messages-from-your-code#:~:text=The%20subsystem%20string,for%20each%20subsystem%20string.) for this parameter.
			- category: See the [Apple documentation](https://developer.apple.com/documentation/os/generating-log-messages-from-your-code#:~:text=The%20category%20string,for%20these%20strings.) for this parameter.
	 */
	public init(
		subsystem: String = Bundle.main.bundleIdentifier ?? "SwiftLogToOsLog",
		category: String,
		logLevel: Logging.Logger.Level = .debug
	) {
		self.oslogger = os.Logger(subsystem: subsystem, category: category)
		self.logLevel = logLevel
	}

	/**
		This Initializer may not be passed directly to
		[LoggingSystem.bootstrap](https://swiftpackageindex.com/apple/swift-log/1.10.1/documentation/logging/loggingsystem/bootstrap(_:)).
		Use it, when you've already a fully configured [os.Logger](https://developer.apple.com/documentation/os/logging)
		instance.
	 */
	public init(oslog: os.Logger, logLevel: Logging.Logger.Level = .debug) {
		self.oslogger = oslog
		self.logLevel = logLevel
	}

	/**
		This function is called by [SwiftLog](https://github.com/apple/swift-log).
	 */
	public func log(
		level: Logging.Logger.Level,
		message: Logging.Logger.Message,
		metadata: Logging.Logger.Metadata?,
		source: String,
		file: String,
		function: String,
		line: UInt
	) {
		let metadataCSV = Self.joinMetadata(self.metadata, self.metadataProvider?.get(), metadata)
		let messageParts = [message.description, metadataCSV]

		let message = messageParts.compactMap { $0 }.joined(separator: " -> ")
		self.oslogger.log(level: OSLogType.from(loggerLevel: level), "\(message)")
	}

	/**
		Use subscripts on struct instances, to add metadata for all future log messages.
	 */
	public subscript(metadataKey metadataKey: String) -> Logging.Logger.Metadata.Value? {
		get {
			return self.metadata[metadataKey]
		}
		set {
			self.metadata[metadataKey] = newValue
		}
	}
	
	private static func joinMetadata(_ metadataList: Logging.Logger.Metadata?...) -> String? {
		var metadataAggregator: Logging.Logger.Metadata = [:]
		for metadata in metadataList {
			guard let metadata = metadata else { continue }
			metadataAggregator.merge(metadata) { return $1 }
		}
		return Self.joinMetadata(metadataAggregator)
	}

	private static func joinMetadata(_ metadata: Logging.Logger.Metadata, with separator: String = ", ") -> String? {
		guard !metadata.isEmpty else { return nil }
		return metadata.map { "\($0) = \($1)" }.joined(separator: separator)
	}
}
