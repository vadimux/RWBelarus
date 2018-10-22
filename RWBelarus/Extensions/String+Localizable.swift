//
//  String+Localizable.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/22/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

