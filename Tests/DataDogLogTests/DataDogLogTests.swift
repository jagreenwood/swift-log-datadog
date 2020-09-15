import XCTest
@testable import DataDogLog

class TestSession: Session {
    var source: String?
    var tags: String?
    var hostname: String?
    var message: String?

    func send(_ log: Log, key: String, region: Region, handler: @escaping (Result<StatusCode, Error>) -> ()) {
        source = log.ddsource
        tags = log.ddtags
        hostname = log.hostname
        message = log.message
    }
}

final class DataDogLogTests: XCTestCase {
    func testLog() {
        let expectedMessage = "Testing swift-log-data-dog"
        let expectedSource = "com.swift-log"
        let expectedHostname = "xctest"
        let expectedTags = "callsite:test-function:100,foo:bar,log:swift"

        var handler = DataDogLogHandler(label: expectedSource, key: "", hostname: expectedHostname)
        handler.metadata = ["foo":"bar"]
        handler.session = TestSession()
        handler.log(level: .error, message: "\(expectedMessage)", metadata: ["log":"swift"], file: "test-file", function: "test-function", line: 100)

        guard let session = handler.session as? TestSession else {
            XCTAssert(false, "Invalid Test")
            return
        }

        XCTAssert(session.message!.contains(expectedMessage), "Expected \(expectedMessage), result was \(String(describing: session.message))")
        XCTAssertEqual(expectedSource, session.source, "Expected \(expectedSource), result was \(String(describing: session.source))")
        XCTAssertEqual(expectedHostname, session.hostname, "Expected \(expectedHostname), result was \(String(describing: session.hostname))")
        XCTAssertEqual(expectedTags, session.tags, "Expected \(expectedTags), result was \(String(describing: session.tags))")
    }
    
    func testRegionURL() {
        let euLogHandler = DataDogLogHandler(label: "test", key: "test", region: .EU)
        let usLogHandler = DataDogLogHandler(label: "test", key: "test", region: .US)
        let defaultLogHandler = DataDogLogHandler(label: "test", key: "test")
        
        XCTAssert(euLogHandler.region == .EU)
        XCTAssert(euLogHandler.region.getURL().absoluteString == "https://http-intake.logs.datadoghq.eu/v1/input")
        XCTAssert(usLogHandler.region == .US)
        XCTAssert(usLogHandler.region.getURL().absoluteString == "https://http-intake.logs.datadoghq.com/v1/input")
        XCTAssert(defaultLogHandler.region == .US)
    }

    static var allTests = [
        ("testLog", testLog),
    ]
}
