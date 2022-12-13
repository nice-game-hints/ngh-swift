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

public func hintFiles(resourceUrl:URL) throws -> [String:String] {
    let fm      = FileManager.default
    let items   = try fm.contentsOfDirectory(atPath: resourceUrl.path)
    print("Found following items:")
    print(items)

    var nghFiles: [ String: String ] = [:]
    
    for item in items {
        // print("Found \(item)")
        let contents = fm.contents(atPath: "\(resourceUrl.path)/\(item)")
        // print(String(data: contents!, encoding:.utf8)!)
        nghFiles[item] = String(data: contents!, encoding:.utf8)!
    }
    return nghFiles
}

public func hintFiles(at folderReference:String) throws -> [String:String] {
  return try hintFiles(resourceUrl: Bundle.main.resourceURL!.appendingPathComponent(folderReference))
}

public struct NGHints {
  public private(set) var text = "Hello, World!"
  private var nghHints: JXValue
  private var jsc: JXContext

  public init(nghFiles: [String: String], lang: String? = nil) throws {
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
    jsc = JXContext()
    try jsc.eval("module = { exports: {} }")
    try jsc.eval(inString)
    let e = try jsc.global["module"]["exports"]
    let jsNGHints = try e["NGHints"]
    assert(jsNGHints.isConstructor == true)
    nghHints = try jsNGHints.construct(withArguments: try [ jsc.encode(nghFiles), lang ])
  }

  func getGuides (progress: [String: Bool] = [:]) throws -> Array<Guide> {
    let getGuides = try nghHints["getGuides"]
    assert(getGuides.isFunction == true)
    let guides = try getGuides.call(withArguments: try [ jsc.encode(progress) ], this: nghHints)
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

