import XCTest
import Foundation

import variable_injector_core

final class ArgumentsHandlerTests: XCTestCase {
    
    func testParseParameters() throws {
        let args = ["argument", "--file", "/file.swift", "--include", "PATH", "--exclude", "PATHS"]
        let arguments = ArgumentsHandler(args: args)

        XCTAssertEqual(arguments.argumentValues(for: "file"), ["/file.swift"])
        XCTAssertEqual(arguments.argumentValues(for: "include"), ["PATH"])
        XCTAssertEqual(arguments.argumentValues(for: "exclude"), ["PATHS"])
    }
    
    func testParseParametersWithEmpty() throws {
        let args = ["argument", "--file", "--include", "PATH", "--exclude", "PATHS"]
        let arguments = ArgumentsHandler(args: args)
        
        XCTAssertNil(arguments.argumentValue(for: "file"))
        XCTAssertEqual(arguments.argumentValues(for: "include"), ["PATH"])
        XCTAssertEqual(arguments.argumentValues(for: "exclude"), ["PATHS"])
    }
    
    static var allTests = [
        ("testParseParameters", testParseParameters),
        ("testParseParametersWithEmpty", testParseParametersWithEmpty)
    ]
}
