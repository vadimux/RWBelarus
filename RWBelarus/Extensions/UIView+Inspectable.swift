//
//  UIView+Inspectable.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/22/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

extension UILabel {
    
    @IBInspectable var localizedText: String? {
        get {
            return self.text
        }
        set {
            guard let newValue = newValue else {
                self.text = ""
                return
            }
            self.text = newValue.localized
        }
    }
}

extension UINavigationItem {
    @IBInspectable var localizedTitle: String? {
        get {
            return title
        }
        set {
            guard let newValue = newValue else {
                title = nil
                return
            }
            let localizedString = NSLocalizedString(newValue, comment: "")
            title = localizedString
        }
    }
}

extension UIBarButtonItem {
    @IBInspectable var localizedTitle: String? {
        get {
            return title
        }
        set {
            guard let newValue = newValue else {
                title = nil
                return
            }
            let localizedString = NSLocalizedString(newValue, comment: newValue)
            title = localizedString
        }
    }
}

extension UIButton {
    @IBInspectable var localizedTitle: String? {
        get {
            return self.title(for: .normal)
        }
        set {
            guard let newValue = newValue else {
                self.setTitle(nil, for: .normal)
                return
            }
            let localizedString = NSLocalizedString(newValue, comment: newValue)
            self.setTitle(localizedString, for: .normal)
        }
    }
}

extension UITabBarItem {
    @IBInspectable var localizedTitle: String? {
        get {
            return title
        }
        set {
            guard let newValue = newValue else {
                title = nil
                return
            }
            let localizedString = NSLocalizedString(newValue, comment: newValue)
            title = localizedString
        }
    }
}
