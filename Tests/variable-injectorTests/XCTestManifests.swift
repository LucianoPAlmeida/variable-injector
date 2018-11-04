import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(VariableInjectorTests.allTests),
        testCase(ArgumentsHandlerTests.allTests)
    ]
}
#endif
