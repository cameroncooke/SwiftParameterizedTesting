//
//  ParameterizedTestCase.swift
//  Copyright © 2023 Cameron Cooke. All rights reserved.
//

import Foundation
import XCTest

open class ParameterizedTestCase: XCTestCase {

    // MARK: - Open -

    open class var testNameFieldSeparator: String {
        "_"
    }

    // MARK: - Internal -

    private var storage: [String: Any] = [:]

    func setValue<T>(_ value: T, forKey key: String) {
        storage[key] = value
    }

    func getValue<T>(forKey key: String) -> T? {
        return storage[key] as? T
    }

    static func testName(for values: [Any]) -> String {
        values
            .map { String(describing: $0) }
            .joined(separator: testNameFieldSeparator)
            .lowercased()
    }
}
