import XCTest
@testable import ngh

final class rootTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        var nghFiles: [ String: String ] = [:]
        nghFiles["a.md"] = """
    ---
    title: TitleA
    ---

    Intro for A
    """
        let target = try NGHints(nghFiles: nghFiles)
        XCTAssertEqual(try target.getGuides()[0].title, "TitleA")
    }
}
