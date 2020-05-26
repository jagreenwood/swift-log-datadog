import XCTest
@testable import DataDogLog

final class DataDogLogTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DataDogLog().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
