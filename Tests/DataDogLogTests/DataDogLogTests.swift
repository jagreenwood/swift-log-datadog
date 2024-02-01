import XCTest
@testable import DataDogLog

class TestSession: Session {
    var source: String?
    var tags: String?
    var hostname: String?
    var message: String?
    var service: String?

    func send(_ log: Log, key: String, region: Region, handler: @escaping (Result<StatusCode, Error>) -> ()) {
        source = log.ddsource
        tags = log.ddtags
        hostname = log.hostname
        message = log.message
        service = log.service
    }
}

final class DataDogLogTests: XCTestCase {
    func testLog() {
        let expectedMessage = "Testing swift-log-data-dog"
        let expectedSource = "swift-log"
        let expectedHostname = "xctest"
        let expectedTags = "callsite:test-function:100,foo:bar,log:swift"
        let expectedService = "com.swift-log"

        var handler = DataDogLogHandler(label: expectedService, key: "", hostname: expectedHostname)
        handler.metadata = ["foo":"bar"]
        handler.session = TestSession()
        handler.log(level: .error, message: "\(expectedMessage)", metadata: ["log":"swift"], source: expectedSource, file: "test-file", function: "test-function", line: 100)

        guard let session = handler.session as? TestSession else {
            XCTAssert(false, "Invalid Test")
            return
        }

        XCTAssert(session.message!.contains(expectedMessage), "Expected \(expectedMessage), result was \(String(describing: session.message))")
        XCTAssertEqual(expectedSource, session.source, "Expected \(expectedSource), result was \(String(describing: session.source))")
        XCTAssertEqual(expectedHostname, session.hostname, "Expected \(expectedHostname), result was \(String(describing: session.hostname))")
        XCTAssertEqual(expectedTags, session.tags, "Expected \(expectedTags), result was \(String(describing: session.tags))")
        XCTAssertEqual(expectedService, session.service, "Expected \(expectedService), result was \(String(describing: session.service))")
    }
    
    func testRegionURL() {
        let euLogHandler = DataDogLogHandler(label: "test", key: "test", region: .EU)
        let usLogHandler = DataDogLogHandler(label: "test", key: "test", region: .US)
        let defaultLogHandler = DataDogLogHandler(label: "test", key: "test")
        
        XCTAssert(euLogHandler.region == .EU)
        XCTAssert(euLogHandler.region.url.absoluteString == "https://http-intake.logs.datadoghq.eu/api/v2/logs")
        XCTAssert(usLogHandler.region == .US)
        XCTAssert(usLogHandler.region.url.absoluteString == "https://http-intake.logs.datadoghq.com/api/v2/logs")
        XCTAssert(defaultLogHandler.region == .US)
    }

    static var allTests = [
        ("testLog", testLog),
    ]
}
