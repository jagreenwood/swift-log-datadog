import Foundation

public enum Region: Sendable {
    case EU, US, US3, US5, US1FED
}

extension Region {
    var url: URL {
        switch (self) {
        case .EU: URL(string: "https://http-intake.logs.datadoghq.eu/api/v2/logs")!
        case .US: URL(string: "https://http-intake.logs.datadoghq.com/api/v2/logs")!
        case .US3: URL(string: "https://http-intake.logs.us3.datadoghq.com/api/v2/logs")!
        case .US5: URL(string: "https://http-intake.logs.us5.datadoghq.com/api/v2/logs")!
        case .US1FED: URL(string: "https://http-intake.logs.ddog-gov.com/api/v2/logs")!
        }
    }
}
