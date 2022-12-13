import XCTest
@testable import ngh

final class rootTests: XCTestCase {
    func testExample() throws {
        let testFixtureFolder = Bundle.module.resourceURL!.appendingPathComponent("fixtures/basic")
        print(testFixtureFolder)
        let files = try hintFiles(resourceUrl: testFixtureFolder)
        let target = try NGHints(nghFiles: files)
        XCTAssertEqual(try target.getGuides().count, 1)
        XCTAssertEqual(try target.getGuides()[0].title, "TitleA")
        XCTAssertEqual(try target.getGuides()[0].hints[0].title, "Hint A1")
        XCTAssertEqual(try target.getGuides()[0].hints[1].spoiler, true)
        XCTAssertEqual(try target.getGuides(progress: [ "prg-a": true, "prg-x": false]).count, 2)
        XCTAssertEqual(try target.getGuides(progress: [ "prg-a": true ])[1].title, "TitleB")
        XCTAssertEqual(try target.getGuides(progress: [ "prg-a": true ])[1].hints.count, 1)
        XCTAssertEqual(try target.getGuides(progress: [ "prg-a": true, "prg-x": true ])[1].hints.count, 2)
        XCTAssertEqual(try target.getGuides(progress: [ "prg-a": true, "prg-x": true, "prg-non-existing": true ])[1].hints.count, 2)
    }
    func testTranslation() throws {
        let testFixtureFolder = Bundle.module.resourceURL!.appendingPathComponent("fixtures/basic")
        print(testFixtureFolder)
        let files = try hintFiles(resourceUrl: testFixtureFolder)
        let target = try NGHints(nghFiles: files, lang: "fi")
        XCTAssertEqual(try target.getGuides().count, 1)
        XCTAssertEqual(try target.getGuides()[0].title, "FinA")
    }
}
