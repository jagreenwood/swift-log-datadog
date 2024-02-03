import Logging

extension Logger.Metadata {
    var prettified: String? {
        !isEmpty ? map { "\($0):\($1)" }
            .sorted(by: <)
            .joined(separator: ",") : nil
    }
}
