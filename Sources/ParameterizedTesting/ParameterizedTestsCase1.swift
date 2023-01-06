//
//  ParameterizedTestsCase1.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest

open class ParameterizedTestCase1<IN1, OUT>: ParameterizedTestCase {
    // MARK: - Open -

    open override class var defaultTestSuite: XCTestSuite {
        customTestSuite(Self.self)
    }

    open class func values() -> ([IN1]) {
        fatalError("Not implemented")
    }

    open class func expectedValues() -> [OUT]? {
        nil
    }

    open class func testName(
        _ value1: IN1
    ) -> String {
        testName(
            for: [
                value1,
            ]
        )
    }

    open func testAllCombinations(_ value1: IN1, _ expectedResult: OUT?) {
        fatalError("Not implemented")
    }

    // MARK: - Internal -

    func getValue1() -> IN1? {
        getValue(forKey: ParameterizedTestCaseKey.value1)
    }

    func getExpectedValue() -> OUT? {
        getValue(forKey: ParameterizedTestCaseKey.expectedValue)
    }

    @objc
    func internalHandler() {
        guard let value1 = getValue1() else {
            preconditionFailure("Params not set")
        }

        let expectedValue = getExpectedValue()
        testAllCombinations(value1, expectedValue)
    }

    // MARK: - Private -

    private static func customTestSuite(_ subclassType: (some XCTestCase).Type) -> XCTestSuite {
        let suite = XCTestSuite(forTestCaseWithName: UUID().uuidString)
        let params1 = values()

        var counter = 0
        let totalCombinations = params1.count
        let expectedValues = expectedValues()

        ParameterizedTestHandler.allCombinations(
            params1,
            { value1 in

                let selector = ParameterizedTestCase1.registerTestMethod(
                    name: testName(value1),
                    testMethod: #selector(self.internalHandler),
                    separator: testNameFieldSeparator
                )

                let testCase = subclassType.init(selector: selector)
                guard let test = testCase as? ParameterizedTestCase else {
                    fatalError("Unable to instantiate XCTestCase")
                }
                
                test.setValue(value1, forKey: ParameterizedTestCaseKey.value1)

                if let expectedValues {
                    if expectedValues.count == totalCombinations {
                        let expectedValue = expectedValues[counter]
                        test.setValue(expectedValue, forKey: ParameterizedTestCaseKey.expectedValue)

                    } else {
                        preconditionFailure(
                            "The number of expected values (\(expectedValues.count)) does not satisfy the total number of all combinations of values (\(totalCombinations))."
                        )
                    }
                }

                suite.addTest(test)
                counter += 1
            }
        )

        return suite
    }
}
