import Logging

/// Attribute for Datadog Logs
///
/// See https://docs.datadoghq.com/api/latest/logs/#send-logs-v1
@usableFromInline
struct Log: Encodable, Sendable {
    let ddsource: String
    let ddtags: String
    let hostname: String
    let message: String
    let service: String
    
    /// Log Status
    ///
    /// Logger.Level.trace will be sorted into Datadog as .debug.
    /// See https://docs.datadoghq.com/logs/processing/processors/#log-status-remapper for details.
    let status: String
}

@usableFromInline
struct Message: CustomStringConvertible, Sendable {
    @usableFromInline
    var description: String {
        "\(String.timestamp) \(level.rawValue.uppercased()): \(message)"
    }
    
    let level: Logger.Level
    let message: String
}

@usableFromInline
struct LogProvider {

    @usableFromInline
    static func build(
        globalMetadata: Logger.Metadata,
        hostname: String?,
        level: Logger.Level,
        label: String,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) -> Log {
        let callsite: [String: Logger.MetadataValue] = ["callsite": "\(function):\(line)"]
        let logMetadata = metadata.map { $0.merging(callsite) { $1 } } ?? callsite
        let mergedMetadata = globalMetadata.merging(logMetadata) { $1 }
        let ddMessage = Message(level: level, message: "\(message)")
        return Log(
            ddsource: source,
            ddtags: "\(mergedMetadata.prettified.map { "\($0)" } ?? "")",
            hostname: hostname ?? "",
            message: "\(ddMessage)",
            service: label,
            status: "\(level)")
    }
}
