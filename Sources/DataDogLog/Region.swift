import Foundation

public enum Region {
    case EU, US, US3, US5, US1FED
}

extension Region {
    func getURL() -> URL {
        switch (self) {
        case .EU:
            return URL(string: "https://http-intake.logs.datadoghq.eu/api/v2/logs")!
        case .US:
            return URL(string: "https://http-intake.logs.datadoghq.com/api/v2/logs")!
        case .US3:
            return URL(string: "https://http-intake.logs.us3.datadoghq.com/api/v2/logs")!
        case .US5:
            return URL(string: "https://http-intake.logs.us5.datadoghq.com/api/v2/logs")!
        case .US1FED:
            return URL(string: "https://http-intake.logs.ddog-gov.com/api/v2/logs")!
        }
    }
}
