import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FFHackyNavBarTests.allTests),
    ]
}
#endif
