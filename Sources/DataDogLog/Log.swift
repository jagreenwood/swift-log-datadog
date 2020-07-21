import Logging

/// https://docs.datadoghq.com/logs/log_collection/?tab=http#reserved-attributes
struct Log: Encodable {
    let ddsource: String
    let ddtags: String
    let hostname: String
    let message: String
    let status: String
}

struct Message: CustomStringConvertible {
    var description: String {
        "\(String.timestamp) \(level.rawValue.uppercased()): \(message)"
    }

    let level: Logger.Level
    let message: String
}
