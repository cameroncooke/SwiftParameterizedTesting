//
//  ParameterizedTestsCase2.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest

public class ParameterizedTestCase2<IN1, IN2, OUT>: XCTestCase {
    // MARK: - Public -

    public class func customTestSuite(_ subclassType: (some XCTestCase).Type) -> XCTestSuite {
        let suite = XCTestSuite(forTestCaseClass: Self.self)
        let (params1, params2) = values()

        var counter = 0
        let totalCombinations = params1.count * params2.count
        let expectedValues = expectedValues()

        ParameterizedTestHandler.allCombinations(
            params1,
            params2,
            { value1, value2 in

                let selector = ParameterizedTestCase2.registerTestMethod(
                    name: "\(value1)_\(value2)".lowercased(),
                    testMethod: #selector(self.internalHandler)
                )

                let test = subclassType.init(selector: selector)
                test.setValue(value: value1, forKey: &ParameterizedTestCaseKey.value1)
                test.setValue(value: value2, forKey: &ParameterizedTestCaseKey.value2)

                if let expectedValues {
                    if expectedValues.count == totalCombinations {
                        let expectedValue = expectedValues[counter]
                        test.setValue(value: expectedValue, forKey: &ParameterizedTestCaseKey.expectedValue)

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

    public class func values() -> ([IN1], [IN2]) {
        fatalError("Not implemented")
    }

    public class func expectedValues() -> [OUT]? {
        nil
    }

    public func testAllCombinations(_ value1: IN1, _ value2: IN2, _ expectedResult: OUT?) {
        fatalError("Not implemented")
    }

    // MARK: - Internal -

    func getValue1() -> IN1? {
        getValue(forKey: &ParameterizedTestCaseKey.value1)
    }

    func getValue2() -> IN2? {
        getValue(forKey: &ParameterizedTestCaseKey.value2)
    }

    func getExpectedValue() -> OUT? {
        getValue(forKey: &ParameterizedTestCaseKey.expectedValue)
    }

    @objc
    func internalHandler() {
        guard let value1 = getValue1(), let value2 = getValue2() else {
            preconditionFailure("Params not set")
        }

        let expectedValue = getExpectedValue()
        testAllCombinations(value1, value2, expectedValue)
    }
}