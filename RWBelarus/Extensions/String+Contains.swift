//
//  contains.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/5/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

extension String {
    func contains(find: String) -> Bool {
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
