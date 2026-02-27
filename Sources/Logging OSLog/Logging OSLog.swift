import Foundation
import os
import Logging

public struct LoggingOSLog: LogHandler {
	public var logLevel: Logging.Logger.Level = .info
	public var metadata: Logging.Logger.Metadata = [:]
	public var metadataProvider: Logging.Logger.MetadataProvider?
	private let oslogger: os.Logger

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

	public init(
		subsystem: String = Bundle.main.bundleIdentifier ?? "SwiftLogToOsLog",
		category: String,
		logLevel: Logging.Logger.Level = .debug
	) {
		self.oslogger = os.Logger(subsystem: subsystem, category: category)
		self.logLevel = logLevel
	}

	public init(oslog: os.Logger, logLevel: Logging.Logger.Level = .debug) {
		self.oslogger = oslog
		self.logLevel = logLevel
	}

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