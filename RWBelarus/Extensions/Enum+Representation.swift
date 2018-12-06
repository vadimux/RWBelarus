//
//  Enum+Representation.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 12/6/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

// To support Swift 4.2's iteration over enum... see
// source: https://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type
public protocol CaseIterable {
    associatedtype AllCases: Collection where AllCases.Element == Self
    associatedtype BaseType: Equatable
    static var allCases: AllCases { get }
    func value() -> BaseType
}

extension CaseIterable where Self: Hashable {
    
    static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
    
    static func find(_ v: BaseType) -> Self? {
        for value in allCases {
            if value.value() == v {
                return value
            }
        }
        return nil
    }
}
