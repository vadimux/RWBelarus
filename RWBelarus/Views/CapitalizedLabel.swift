//
//  CapitalizedLabel.swift
//  RWBelarus
//
//  Created by ws-056-41b on 9/25/19.
//  Copyright © 2019 mikalayeu. All rights reserved.
//

import UIKit

class CapitalizedLabel: UILabel {
    
    override var text: String? {
        didSet {
            super.text = text?.uppercased()
        }
    }

}
