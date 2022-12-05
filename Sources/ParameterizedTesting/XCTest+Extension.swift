//
//  XCTest+Extension.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import ObjectiveC
import XCTest

extension XCTestCase {
    class func registerTestMethod(name: String, testMethod: Selector) -> Selector {
        let selector = makeSelector(with: name)

        if let existingMethod = class_getInstanceMethod(self, selector) {

            let mthd = class_replaceMethod(
                self,
                selector,
                method_getImplementation(existingMethod),
                method_getTypeEncoding(existingMethod)
            )
            precondition(mthd != nil, "Could not update test method.")

        } else {

            let method = class_getInstanceMethod(self, testMethod)
            let success = class_addMethod(
                self,
                selector,
                method_getImplementation(method!),
                method_getTypeEncoding(method!)
            )
            precondition(success, "Could not create test method.")
        }

        return selector
    }

    func setValue(value: some Any, forKey key: UnsafeMutablePointer<String>) {

        if let value: AnyObject = getValue(forKey: key) {
            objc_removeAssociatedObjects(value)
        }

        let object = self as AnyObject
        objc_setAssociatedObject(
            object,
            key,
            value,
            .OBJC_ASSOCIATION_RETAIN
        )
    }

    func getValue<T>(forKey key: UnsafeMutablePointer<String>) -> T? {
        let object = self as AnyObject
        return objc_getAssociatedObject(
            object,
            key
        ) as? T
    }

    private static func makeSelector(with name: String) -> Selector {
        // TODO: Remove special characters and spaces
        // (technically they will work as we're using selectors but just to be on safe side)
        let selector = sel_registerName("test_\(name)")
        return selector
    }
}
