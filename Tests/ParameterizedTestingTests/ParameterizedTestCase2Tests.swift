//
//  ParameterizedTestCase2Tests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import SnapshotTesting
import XCTest
@testable import ParameterizedTesting

final class ParameterizedTestCase2Tests: XCTestCase {

    // MARK: - Internal -

    func testTestsAreCreatedForAllCombinations() {
        let suite = Tests.defaultTestSuite
        let tests = suite.tests
        XCTAssertEqual(tests.count, 20)
    }

    func testAllCombinationsIsCalledForEachCombinationOfValues() {
        var combinations: [String] = []

        let suite = Tests.defaultTestSuite
        suite.tests.forEach { test in
            guard let test = test as? Tests else {
                XCTFail()
                return
            }

            test.handler = {
                _ = $2
                combinations.append("\($0)_\($1)")
            }

            test.invokeTest()
        }

        assertSnapshot(matching: combinations, as: .json)
    }

    func testAllCombinationsIsCalledWithCorrespondingExpectedValues() {
        var valueStrings: [String] = []
        var expectedResults: [String?] = []

        let suite = Tests.defaultTestSuite
        suite.tests.forEach { test in
            guard let test = test as? Tests else {
                XCTFail()
                return
            }

            test.handler = {
                valueStrings.append("\($0)_\($1)")
                expectedResults.append($2)
            }

            test.invokeTest()
        }

        XCTAssertEqual(valueStrings, expectedResults)
    }
}

// TestCase under test

private final class Tests: ParameterizedTestCase2<
    String,
    Int,
    String
> {
    var handler: (
        (
            _ value1: String,
            _ value2: Int,
            _ expectedResult: String?
        ) -> Void
    ) = { _, _, _ in }

    override class func values() -> (
        [String],
        [Int]
    ) {
        (
            TestData.values1,
            TestData.values2
        )
    }

    override class func expectedValues() -> [String]? {
        // Programmatically generate expected results
        var expected: [String] = []
        ParameterizedTestHandler.allCombinations(
            TestData.values1,
            TestData.values2
        ) {
            expected.append("\($0)_\($1)")
        }
        return expected
    }

    override func testAllCombinations(
        _ value1: String,
        _ value2: Int,
        _ expectedResult: String?
    ) {
        handler(
            value1,
            value2,
            expectedResult
        )
    }
}
