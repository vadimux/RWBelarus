//
//  UIView+Designable.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/26/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue >= 0 ? newValue : frame.size.height / 4
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue >= 0 ? newValue : 0
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
