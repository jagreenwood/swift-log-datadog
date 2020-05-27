import Logging

struct Log: Encodable {
    let ddsource: String
    let ddtags: String
    let hostname: String
    let message: String
}

struct Message: CustomStringConvertible {
    var description: String {
        "\(String.timestamp) \(level.rawValue.uppercased()): \(message)"
    }

    let level: Logger.Level
    let message: String
}
