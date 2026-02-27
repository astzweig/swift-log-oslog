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