import Logging

/// Attribute for Datadog Logs
///
/// See https://docs.datadoghq.com/logs/log_collection/#reserved-attributes
struct Log: Encodable {
    let ddsource: String
    let ddtags: String
    let hostname: String
    let message: String
    
    /// Log Status
    ///
    /// Logger.Level.trace will be sorted into Datadog as .debug.
    /// See https://docs.datadoghq.com/logs/processing/processors/#log-status-remapper for details.
    let status: String
}

struct Message: CustomStringConvertible {
    var description: String {
        "\(String.timestamp) \(level.rawValue.uppercased()): \(message)"
    }

    let level: Logger.Level
    let message: String
}
