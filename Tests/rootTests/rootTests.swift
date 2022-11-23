import XCTest
@testable import ngh

final class rootTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        var nghFiles: [ String: String ] = [:]
        nghFiles["_status.yml"] = """
- prg-a:
    title: PRG A
- prg-x:
    title: PRG X
"""
        nghFiles["a.md"] = """
---
title: TitleA
order: 10
---

Intro for A

# Hint A1
Text A1

## Hint A2
Text A2
"""
        nghFiles["b.md"] = """
---
title: TitleB
order: 20
when: prg-a
---

Intro for B

# Hint B1 ((when prg-x))
Text B1

## Hint B2
Text B2
"""
        let target = try NGHints(nghFiles: nghFiles)
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
}
