import XCTest
import Foundation

import VariableInjector

final class ArgumentsHandlerTests: XCTestCase {
    
    func testParseParameters() throws {
        let args = ["argument", "--file", "/file.swift", "--include", "PATH", "--exclude", "PATHS"]
        let arguments = ArgumentsHandler(args: args)

        let expected = [Argument(name: "file", values: ["/file.swift"]),
                        Argument(name: "include", values: ["PATH"]),
                        Argument(name: "exclude", values: ["PATHS"])]

        XCTAssertEqual(arguments._parsedArgs, expected)
    }
    
    func testParseParametersWithEmpty() throws {
        let args = ["argument", "--file", "--include", "PATH", "--exclude", "PATHS"]
        let arguments = ArgumentsHandler(args: args)
        
        let expected = [Argument(name: "file"),
                        Argument(name: "include", values: ["PATH"]),
                        Argument(name: "exclude", values: ["PATHS"])]
        
        XCTAssertEqual(arguments._parsedArgs, expected)
    }
    
    static var allTests = [
        ("testParseParameters", testParseParameters),
    ]
}
