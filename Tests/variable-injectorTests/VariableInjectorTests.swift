import XCTest
import SwiftSyntax
import variable_injector_core

final class VariableInjectorTests: XCTestCase {
    
    let testSource = """
        import Foundation

        class Envirionment {
            static var serverURL: String = "$(SERVER_URL)"
            var apiVersion: String = "$(API_VERSION)"
        }
    """
    
    override func setUp() {
        // Work around https://bugs.swift.org/browse/SR-2866
        try? testSource.write(to: Bundle(for: type(of: self)).bundleURL.appendingPathComponent("TestFile.swift"), atomically: true, encoding: .utf8)
    }
    
    func testVariableSubstitution() throws {
        let stubEnvirionment = ["SERVER_URL": "http://ci.injected.server.url.com"]
        
        let url = Bundle(for: type(of: self)).bundleURL.appendingPathComponent("TestFile.swift")
        let sourceFile = try SyntaxTreeParser.parse(url)
        
        let envVarRewriter = EnvirionmentVariableLiteralRewriter(envirionment: stubEnvirionment)
        let result = envVarRewriter.visit(sourceFile)
        
        var contents: String = ""
        result.write(to: &contents)
        
        let expected = testSource.replacingOccurrences(of: "$(SERVER_URL)", with: "http://ci.injected.server.url.com")
        
        
        XCTAssertEqual(expected, contents)
    }
    
    func testVariableSubstitutionWithExclusion() throws {
        let stubEnvirionment = ["SERVER_URL": "http://ci.injected.server.url.com", "API_VERSION": "v1"]
        
        let url = Bundle(for: type(of: self)).bundleURL.appendingPathComponent("TestFile.swift")
        let sourceFile = try SyntaxTreeParser.parse(url)
        
        let envVarRewriter = EnvirionmentVariableLiteralRewriter(envirionment: stubEnvirionment, ignoredLiteralValues: ["SERVER_URL"])
        let result = envVarRewriter.visit(sourceFile)
        
        var contents: String = ""
        result.write(to: &contents)
        
        let expected = testSource.replacingOccurrences(of: "$(API_VERSION)", with: "v1")
        
        XCTAssertEqual(expected, contents)
    }
    
    static var allTests = [
        ("testVariableSubstitution", testVariableSubstitution),
        ("testVariableSubstitutionWithExclusion", testVariableSubstitutionWithExclusion),
    ]
}
