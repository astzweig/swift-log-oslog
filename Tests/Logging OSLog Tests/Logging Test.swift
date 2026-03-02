import Testing
import Logging
import LoggingOSLog

@Test func isConstructable() {
	let _ = LoggingOSLog(subsystem: "de.astzweig.app", category: "Image Processing")
}

@Test func canAddAsLoggingBackend() {
	LoggingSystem.bootstrap(LoggingOSLog.init)
}

@Test func canLogMessage() {
	let logger = Logging.Logger(label: "de.astzweig.loggingoslog.Test")
	logger.info("Test message")
}

@Test func canLogMessageWithMetadata() {
	let logger = Logging.Logger(label: "de.astzweig.loggingoslog.Test")
	logger.info("Test message", metadata: [
		"request.id": "20140801",
		"request.dirname": "\"Impossible\"",
		"request.authorization": [
			"bearer": "empty"
		],
		"request.values": ["1", "rootID", ["key": "value"]]
	])
}
