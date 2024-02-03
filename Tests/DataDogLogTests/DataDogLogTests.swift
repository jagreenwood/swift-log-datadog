import XCTest
@testable import DataDogLog

final class DataDogLogTests: XCTestCase {
    func testLog() {
        let expectedMessage = "Testing swift-log-data-dog"
        let expectedSource = "swift-log"
        let expectedHostname = "xctest"
        let expectedTags = "callsite:test-function:100,foo:bar,log:swift"
        let expectedService = "com.swift-log"

        let log = LogProvider.build(
            globalMetadata: ["foo":"bar"],
            hostname: expectedHostname,
            level: .error,
            label: expectedService,
            message: "\(expectedMessage)",
            metadata: ["log":"swift"],
            source: expectedSource,
            file: "test-file",
            function: "test-function",
            line: 100
        )

        XCTAssert(log.message.contains(expectedMessage), "Expected \(expectedMessage), result was \(log.message)")
        XCTAssertEqual(expectedSource, log.ddsource, "Expected \(expectedSource), result was \(log.ddsource)")
        XCTAssertEqual(expectedHostname, log.hostname, "Expected \(expectedHostname), result was \(log.hostname)")
        XCTAssertEqual(expectedTags, log.ddtags, "Expected \(expectedTags), result was \(log.ddtags)")
        XCTAssertEqual(expectedService, log.service, "Expected \(expectedService), result was \(log.service)")
    }

    func testRegionURL() {
        let euLogHandler = DataDogLogHandler(label: "test", key: "test", site: .EU)
        let usLogHandler = DataDogLogHandler(label: "test", key: "test", site: .US)
        let defaultLogHandler = DataDogLogHandler(label: "test", key: "test")

        XCTAssert(euLogHandler.site == .EU)
        XCTAssert(euLogHandler.site.url.absoluteString == "https://http-intake.logs.datadoghq.eu/api/v2/logs")
        XCTAssert(usLogHandler.site == .US)
        XCTAssert(usLogHandler.site.url.absoluteString == "https://http-intake.logs.datadoghq.com/api/v2/logs")
        XCTAssert(defaultLogHandler.site == .US)
    }
}
