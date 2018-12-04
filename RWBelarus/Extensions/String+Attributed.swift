//
//  String+Attributed.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 12/5/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var attributedRegularString: NSAttributedString {
        return attributedRegularStringWithSize()
    }
    
    var attributedBoldString: NSAttributedString {
        return attributedBoldStringWithSize()
    }
    
    internal func attributedBoldStringWithSize(_ size: CGFloat = 16, color: UIColor = UIColor.black) -> NSAttributedString {
        return attributedStringWithFont(R.font.robotoMedium(size: size), size: size, color: color)
    }
    
    internal func attributedRegularStringWithSize(_ size: CGFloat = 16, color: UIColor = UIColor.black) -> NSAttributedString {
        return attributedStringWithFont(R.font.robotoRegular(size: size), size: size, color: color)
    }
    
    internal func attributedStringWithFont(_ font: UIFont?, size: CGFloat = 16, color: UIColor = .black) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: size),
                          NSAttributedString.Key.foregroundColor: color]
        return NSAttributedString.init(string: self, attributes: attributes)
    }
}
