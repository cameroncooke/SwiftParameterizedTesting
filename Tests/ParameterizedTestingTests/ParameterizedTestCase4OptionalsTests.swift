//
//  ParameterizedTestCase4OptionalsTests.swift
//  Copyright © 2023 Cameron Cooke. All rights reserved.
//

import SnapshotTesting
import XCTest
@testable import ParameterizedTesting

final class ParameterizedTestCase4OptionalsTests: XCTestCase {

    // MARK: - Internal -

    func testTestsAreCreatedForAllCombinations() {
        let suite = Tests.defaultTestSuite
        let tests = suite.tests
        XCTAssertEqual(tests.count, 16)
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
                _ = $4
                combinations.append("\($0)_\($1)_\($2)_\($3)")
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
                valueStrings.append("\($0)_\($1)_\($2)_\($3)")
                expectedResults.append($4)
            }

            test.invokeTest()
        }

        XCTAssertEqual(valueStrings, expectedResults)
    }
}

// TestCase under test

private final class Tests: ParameterizedTestCase4<
    String?,
    Int?,
    String?,
    String?,
    String
> {
    var handler: (
        (
            _ value1: String?,
            _ value2: Int?,
            _ value3: String?,
            _ value4: String?,
            _ expectedResult: String?
        ) -> Void
    ) = { _, _, _, _, _ in }

    override class func values() -> (
        [String?],
        [Int?],
        [String?],
        [String?]
    ) {
        (
            TestDataWithOptionals.values1,
            TestDataWithOptionals.values2,
            TestDataWithOptionals.values3,
            TestDataWithOptionals.values4
        )
    }

    override class func expectedValues() -> [String] {
        // Programmatically generate expected results
        var expected: [String] = []
        ParameterizedTestHandler.allCombinations(
            TestDataWithOptionals.values1,
            TestDataWithOptionals.values2,
            TestDataWithOptionals.values3,
            TestDataWithOptionals.values4
        ) {
            expected.append("\($0)_\($1)_\($2)_\($3)")
        }
        return expected
    }

    override func testAllCombinations(
        _ value1: String?,
        _ value2: Int?,
        _ value3: String?,
        _ value4: String?,
        _ expectedResult: String?
    ) {
        handler(
            value1,
            value2,
            value3,
            value4,
            expectedResult
        )
    }
}
