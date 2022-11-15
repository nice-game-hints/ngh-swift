// import JavaScriptCore
import JXKit
import Foundation

public struct Hint {
  public var title: String
  public var content: String
  public var spoiler: Bool
}

public struct Guide {
  public var title: String
  public var hints: Array<Hint>
}

public struct NGHints {
  public private(set) var text = "Hello, World!"
  private var nghHints: JXValue

  public init(nghFiles: [String: String]) throws {
    // mod.js is the ngh-js bundled file
    guard let fileURL = Bundle.module.url(forResource: "bundle", withExtension: "js") else {
        fatalError("Not able to create URL for bundled js")
    }

    // Reading it back from the file
    var inString = ""
    do {
        inString = try String(contentsOf: fileURL)
    } catch {
        assertionFailure("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
    }

    // Read the exports default to JXValue
    let jsc = JXContext()
    try jsc.eval("module = { exports: {} }")
    try jsc.eval(inString)
    let e = try jsc.global["module"]["exports"]
    let jsNGHints = try e["NGHints"]
    assert(jsNGHints.isConstructor == true)
    nghHints = try jsNGHints.construct(withArguments: try [ jsc.encode(nghFiles) ])
  }

  func getGuides () throws -> Array<Guide> {
    let getGuides = try nghHints["getGuides"]
    assert(getGuides.isFunction == true)
    let guides = try getGuides.call(this: nghHints)
    return try guides.array.map { (jxG) -> Guide in return Guide(
      title: try jxG["title"].string,
      hints: try jxG["hints"].array.map { (jxH) -> Hint in return Hint(
        title: try jxH["title"].string,
        content: try jxH["content"].string,
        spoiler: try jxH["spoiler"].bool
      )}
    )}
  }
}

