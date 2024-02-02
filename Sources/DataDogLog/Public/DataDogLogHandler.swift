import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

public struct DataDogLogHandler: LogHandler, Sendable {
    public var metadata = Logger.Metadata()
    public var logLevel = Logger.Level.info
    public var label: String
    public var hostname: String?

    @usableFromInline
    internal let key: String

    @usableFromInline
    internal let region: Region

    @usableFromInline
    let networkClient = NetworkClient()

    public init(
        label: String,
        key: String,
        hostname: String? = nil,
        region: Region = .US
    ) {
        self.label = label
        self.key = key
        self.hostname = hostname
        self.region = region
    }

    @inlinable
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
            let statusCode = try await networkClient.send(log, key: key, region: region)
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
