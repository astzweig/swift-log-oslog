import Logging

extension Logging.Logger.Metadata {
	public func asJSON() -> String {
		return Self.asJSON(self)
	}

	private static func asJSON(_ metadata: Logging.Logger.Metadata) -> String {
		var outputParts: [String: String] = [:]
		for (key, value) in metadata {
			let jsonKey = Self.escapeForJSON(key)
			outputParts[jsonKey] = Self.asJSON(value)
		}
		return "{" + outputParts.map { "\"\($0)\": \($1)" }.joined(separator: ", ") + "}"
	}

	private static func asJSON(_ metadata: [Logging.Logger.MetadataValue]) -> String {
		var outputParts: [String] = []
		for item in metadata {
			outputParts.append(Self.asJSON(item))
		}
		return "[" + outputParts.joined(separator: ", ") + "]"
	}

	private static func asJSON(_ metadata: Logging.Logger.MetadataValue) -> String {
		switch metadata {
		case .dictionary(let subvalues):
			return Self.asJSON(subvalues)
		case .array(let subvalues):
			return Self.asJSON(subvalues)
		case .string(let subvalue):
			return "\"" + Self.escapeForJSON(subvalue) + "\""
		case .stringConvertible(let subvalue):
			return "\"" + Self.escapeForJSON("\(subvalue)") + "\""
		}
	}

	private static func escapeForJSON(_ data: String) -> String {
		return data.replacingOccurrences(of: "\"", with: "\\\"")
	}
}
