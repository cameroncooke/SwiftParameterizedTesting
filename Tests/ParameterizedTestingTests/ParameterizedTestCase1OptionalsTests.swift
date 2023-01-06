//
//  ParameterizedTestCase1OptionalsTests.swift
//  Copyright © 2023 Cameron Cooke. All rights reserved.
//

import SnapshotTesting
import XCTest
@testable import ParameterizedTesting

final class ParameterizedTestCase1OptionalsTests: XCTestCase {

    // MARK: - Internal -

    func testTestsAreCreatedForAllCombinations() {
        let suite = Tests.defaultTestSuite
        let tests = suite.tests
        XCTAssertEqual(tests.count, 2)
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
                _ = $1
                combinations.append("\($0)")
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
                valueStrings.append("\($0)")
                expectedResults.append($1)
            }

            test.invokeTest()
        }

        XCTAssertEqual(valueStrings, expectedResults)
    }
}

// TestCase under test

private final class Tests: ParameterizedTestCase1<
    String?,
    String
> {
    var handler: (
        (
            _ value1: String?,
            _ expectedResult: String?
        ) -> Void
    ) = { _, _ in }

    override class func values() -> ([String?]) {
        (
            TestDataWithOptionals.values1
        )
    }

    override class func expectedValues() -> [String] {
        // Programmatically generate expected results
        var expected: [String] = []
        ParameterizedTestHandler.allCombinations(
            TestDataWithOptionals.values1
        ) {
            expected.append("\($0)")
        }
        return expected
    }

    override func testAllCombinations(
        _ value1: String?,
        _ expectedResult: String?
    ) {
        handler(
            value1,
            expectedResult
        )
    }
}
