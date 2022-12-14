//
//  ParameterizedTestsCase3.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest

open class ParameterizedTestCase3<IN1, IN2, IN3, OUT>: ParameterizedTestCase {
    // MARK: - Open -

    open override class var defaultTestSuite: XCTestSuite {
        customTestSuite(Self.self)
    }

    open class func values() -> ([IN1], [IN2], [IN3]) {
        fatalError("Not implemented")
    }

    open class func expectedValues() -> [OUT]? {
        nil
    }

    open class func testName(
        _ value1: IN1,
        _ value2: IN2,
        _ value3: IN3
    ) -> String {
        testName(
            for: [
                value1,
                value2,
                value3
            ]
        )
    }

    open func testAllCombinations(_ value1: IN1, _ value2: IN2, _ value3: IN3, _ expectedResult: OUT?) {
        fatalError("Not implemented")
    }

    // MARK: - Internal -

    func getValue1() -> IN1? {
        getValue(forKey: ParameterizedTestCaseKey.value1)
    }

    func getValue2() -> IN2? {
        getValue(forKey: ParameterizedTestCaseKey.value2)
    }

    func getValue3() -> IN3? {
        getValue(forKey: ParameterizedTestCaseKey.value3)
    }

    func getExpectedValue() -> OUT? {
        getValue(forKey: ParameterizedTestCaseKey.expectedValue)
    }

    @objc
    func internalHandler() {
        guard let value1 = getValue1(), let value2 = getValue2(), let value3 = getValue3() else {
            preconditionFailure("Params not set")
        }

        let expectedValue = getExpectedValue()
        testAllCombinations(value1, value2, value3, expectedValue)
    }

    // MARK: - Private -

    private static func customTestSuite<T: XCTestCase>(_ subclassType: T.Type) -> XCTestSuite {
        let suite = XCTestSuite(forTestCaseWithName: UUID().uuidString)
        let (params1, params2, params3) = values()

        var counter = 0
        let totalCombinations = params1.count * params2.count * params3.count
        let expectedValues = expectedValues()

        ParameterizedTestHandler.allCombinations(
            params1,
            params2,
            params3,
            { value1, value2, value3 in

                let selector = ParameterizedTestCase3.registerTestMethod(
                    name: testName(value1, value2, value3),
                    testMethod: #selector(self.internalHandler),
                    separator: testNameFieldSeparator
                )

                let testCase = subclassType.init(selector: selector)
                guard let test = testCase as? ParameterizedTestCase else {
                    fatalError("Unable to instantiate XCTestCase")
                }

                test.setValue(value1, forKey: ParameterizedTestCaseKey.value1)
                test.setValue(value2, forKey: ParameterizedTestCaseKey.value2)
                test.setValue(value3, forKey: ParameterizedTestCaseKey.value3)

                if let expectedValues = expectedValues {
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
