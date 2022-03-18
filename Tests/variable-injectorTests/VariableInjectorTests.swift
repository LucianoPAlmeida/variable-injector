import XCTest
import SwiftSyntax
import SwiftSyntaxParser
import variable_injector_core

final class VariableInjectorTests: XCTestCase {
    
    let testSource = """
        import Foundation

        class Environment {
            static var serverURL: String = "$(SERVER_URL)"
            var apiVersion: String = "$(API_VERSION)"
            var notReplaceIt: String = "Do not replace it"
        }
    """
    
    func testVariableSubstitution() throws {
        let stubEnvironment = ["SERVER_URL": "http://ci.injected.server.url.com"]
        let sourceFile = try SyntaxParser.parse(source: testSource)
        
        let envVarRewriter = EnvironmentVariableLiteralRewriter(environment: stubEnvironment)
        let result = envVarRewriter.visit(sourceFile)
        
        var contents: String = ""
        result.write(to: &contents)
        
        let expected = testSource.replacingOccurrences(of: "$(SERVER_URL)", with: "http://ci.injected.server.url.com")
        
        
        XCTAssertEqual(expected, contents)
    }
    
    func testVariableSubstitutionWithExclusion() throws {
        let stubEnvironment = ["SERVER_URL": "http://ci.injected.server.url.com", "API_VERSION": "v1"]
        let sourceFile = try SyntaxParser.parse(source: testSource)

        let envVarRewriter = EnvironmentVariableLiteralRewriter(environment: stubEnvironment, ignoredLiteralValues: ["SERVER_URL"])
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
