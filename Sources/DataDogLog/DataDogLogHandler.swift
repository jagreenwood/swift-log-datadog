import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

public struct DataDogLogHandler: LogHandler {
    public var metadata = Logger.Metadata()
    public var logLevel = Logger.Level.info
    public var label: String
    public var hostname: String?

    var session: Session = URLSession.shared

    public init(label: String, hostname: String? = nil) {
        self.label = label
        self.hostname = hostname
    }

    public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, file: String, function: String, line: UInt) {

        // Merge metadata, overriding dupliates with new value
        let mergedMetadata = metadata.map { self.metadata.merging($0) { $1 } } ?? self.metadata
        let ddMessage = Message(level: level, message: "\(message)")
        let log = Log(ddsource: label, ddtags: "\(mergedMetadata.prettified.map { " \($0)" } ?? "")", hostname: self.hostname ?? "", message: "\(ddMessage)")

        session.send(log) { result in
            if case .failure(let message) = result {
                debugPrint(message)
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
