import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A log handler designed to send logs to DataDog
public struct DataDogLogHandler: LogHandler, Sendable {
    /// Global metadata. This metadata will be added to every log message
    public var metadata = Logger.Metadata()

    /// The minimum log level for a message to be logged. If a log's level is more severe or equal to this value, the log will be sent. Defaults to `info`.
    public var logLevel = Logger.Level.info

    /// The label to use for this handler. This is usually the service's name.
    public var label: String

    /// The name of the host sending logs
    public var hostname: String?

    @usableFromInline
    internal let key: String

    @usableFromInline
    internal let site: Site

    @usableFromInline
    let networkClient = NetworkClient()

    /// - Parameters:
    ///   - label: The label to use for this handler
    ///   - key: The DataDog access key
    ///   - hostname: The name of the host sending logs
    ///   - region: The DataDog region to use, defaults to `US`
    public init(
        label: String,
        key: String,
        hostname: String? = nil,
        site: Site = .US
    ) {
        self.label = label
        self.key = key
        self.hostname = hostname
        self.site = site
    }

    @inlinable
    /// - Parameters:
    ///    - level: The log level the message was logged at.
    ///    - message: The message to log. To obtain a `String` representation call `message.description`.
    ///    - metadata: The metadata associated to this log message.
    ///    - source: The source where the log message originated, for example the logging module.
    ///    - file: The file the log message was emitted from.
    ///    - function: The function the log line was emitted from.
    ///    - line: The line the log message was emitted from.
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        let log = LogProvider.build(
            globalMetadata: self.metadata,
            hostname: self.hostname,
            level: level,
            label: self.label,
            message: message,
            metadata: metadata,
            source: source,
            file: file,
            function: function,
            line: line
        )

        Task {
            let statusCode = try await networkClient.send(log, key: key, site: site)
            if !statusCode.success {
                debugPrint("\(statusCode)")
            }
        }
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            metadata[metadataKey]
        }
        set(newValue) {
            metadata[metadataKey] = newValue
        }
    }
}
