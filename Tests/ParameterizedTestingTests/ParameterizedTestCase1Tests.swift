//
//  ParameterizedTestCase1Tests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import SnapshotTesting
import XCTest
@testable import ParameterizedTesting

final class ParameterizedTestCase1Tests: XCTestCase {

    // MARK: - Internal -

    func testTestsAreCreatedForAllCombinations() {
        let suite = Tests.defaultTestSuite
        let tests = suite.tests
        XCTAssertEqual(tests.count, 4)
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
    String,
    String
> {
    var handler: (
        (
            _ value1: String,
            _ expectedResult: String?
        ) -> Void
    ) = { _, _ in }

    override class func values() -> (
        [String]
    ) {
        (
            TestData.values1
        )
    }

    override class func expectedValues() -> [String]? {
        return TestData.values1
    }

    override func testAllCombinations(
        _ value1: String,
        _ expectedResult: String?
    ) {
        handler(
            value1,
            expectedResult
        )
    }
}
