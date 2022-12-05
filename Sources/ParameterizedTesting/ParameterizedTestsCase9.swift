//
//  ParameterizedTestsCase9.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest

open class ParameterizedTestCase9<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, OUT>: XCTestCase {
    // MARK: - Open -

    open class func customTestSuite(_ subclassType: (some XCTestCase).Type) -> XCTestSuite {
        let suite = XCTestSuite(forTestCaseClass: Self.self)
        let (params1, params2, params3, params4, params5, params6, params7, params8, params9) = values()

        var counter = 0
        let totalCombinations = params1.count * params2.count * params3.count * params4.count * params5.count * params6
            .count * params7.count * params8.count * params9.count
        let expectedValues = expectedValues()

        ParameterizedTestHandler.allCombinations(
            params1,
            params2,
            params3,
            params4,
            params5,
            params6,
            params7,
            params8,
            params9,
            { value1, value2, value3, value4, value5, value6, value7, value8, value9 in

                let selector = ParameterizedTestCase9.registerTestMethod(
                    name: "\(value1)_\(value2)_\(value3)_\(value4)_\(value5)_\(value6)_\(value7)_\(value8)_\(value9)"
                        .lowercased(),
                    testMethod: #selector(self.internalHandler)
                )

                let test = subclassType.init(selector: selector)
                test.setValue(value: value1, forKey: &ParameterizedTestCaseKey.value1)
                test.setValue(value: value2, forKey: &ParameterizedTestCaseKey.value2)
                test.setValue(value: value3, forKey: &ParameterizedTestCaseKey.value3)
                test.setValue(value: value4, forKey: &ParameterizedTestCaseKey.value4)
                test.setValue(value: value5, forKey: &ParameterizedTestCaseKey.value5)
                test.setValue(value: value6, forKey: &ParameterizedTestCaseKey.value6)
                test.setValue(value: value7, forKey: &ParameterizedTestCaseKey.value7)
                test.setValue(value: value8, forKey: &ParameterizedTestCaseKey.value8)
                test.setValue(value: value9, forKey: &ParameterizedTestCaseKey.value9)

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

    open class func values() -> ([IN1], [IN2], [IN3], [IN4], [IN5], [IN6], [IN7], [IN8], [IN9]) {
        fatalError("Not implemented")
    }

    open class func expectedValues() -> [OUT]? {
        nil
    }

    open func testAllCombinations(
        _ value1: IN1,
        _ value2: IN2,
        _ value3: IN3,
        _ value4: IN4,
        _ value5: IN5,
        _ value6: IN6,
        _ value7: IN7,
        _ value8: IN8,
        _ value9: IN9,
        _ expectedResult: OUT?
    ) {
        fatalError("Not implemented")
    }

    // MARK: - Internal -

    func getValue1() -> IN1? {
        getValue(forKey: &ParameterizedTestCaseKey.value1)
    }

    func getValue2() -> IN2? {
        getValue(forKey: &ParameterizedTestCaseKey.value2)
    }

    func getValue3() -> IN3? {
        getValue(forKey: &ParameterizedTestCaseKey.value3)
    }

    func getValue4() -> IN4? {
        getValue(forKey: &ParameterizedTestCaseKey.value4)
    }

    func getValue5() -> IN5? {
        getValue(forKey: &ParameterizedTestCaseKey.value5)
    }

    func getValue6() -> IN6? {
        getValue(forKey: &ParameterizedTestCaseKey.value6)
    }

    func getValue7() -> IN7? {
        getValue(forKey: &ParameterizedTestCaseKey.value7)
    }

    func getValue8() -> IN8? {
        getValue(forKey: &ParameterizedTestCaseKey.value8)
    }

    func getValue9() -> IN9? {
        getValue(forKey: &ParameterizedTestCaseKey.value9)
    }

    func getExpectedValue() -> OUT? {
        getValue(forKey: &ParameterizedTestCaseKey.expectedValue)
    }

    @objc
    func internalHandler() {
        guard let value1 = getValue1(), let value2 = getValue2(), let value3 = getValue3(), let value4 = getValue4(),
              let value5 = getValue5(), let value6 = getValue6(), let value7 = getValue7(), let value8 = getValue8(),
              let value9 = getValue9() else {
            preconditionFailure("Params not set")
        }

        let expectedValue = getExpectedValue()
        testAllCombinations(value1, value2, value3, value4, value5, value6, value7, value8, value9, expectedValue)
    }

    open override func tearDown() {
        print("dfdsf")
    }
}
