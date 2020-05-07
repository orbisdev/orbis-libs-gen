import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(orbis_parserTests.allTests),
    ]
}
#endif
