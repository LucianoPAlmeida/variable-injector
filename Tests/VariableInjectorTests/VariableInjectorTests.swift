import XCTest
import class Foundation.Bundle

final class VariableInjectorTests: XCTestCase {
    func testVariableSubstitution() throws {
        
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testVariableSubstitution", testVariableSubstitution),
    ]
}
