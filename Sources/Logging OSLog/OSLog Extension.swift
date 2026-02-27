import Logging
import os

extension OSLogType {
	static func from(loggerLevel: Logging.Logger.Level) -> Self {
		switch loggerLevel {
		case .trace:
			return .debug
		case .debug:
			return .debug
		case .info:
			return .info
		case .notice:
			return .default
		case .warning:
			return .info
		case .error:
			return .error
		case .critical:
			return .fault
		}
	}
}