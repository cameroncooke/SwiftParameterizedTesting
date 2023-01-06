//
//  Optional+Extensions.swift
//  Copyright © 2023 Cameron Cooke. All rights reserved.
//

import Foundation

extension Optional: CustomStringConvertible {
   public var description: String {
       switch self {
       case .some(let value):
           return "\(value)"
       case .none:
           return "null"
       }
   }
}

extension DefaultStringInterpolation {
  mutating func appendInterpolation<T>(_ optional: T?) {
    appendInterpolation(String(describing: optional))
  }
}
