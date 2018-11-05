//
//  CarriageHeader.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/5/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class CarriageHeader: UIView {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var tariffLabel: UILabel!
    @IBOutlet weak var carrierLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    
    class func instanceFromNib() -> UIView? {
        return R.nib.carriageHeader().instantiate(withOwner: nil, options: nil).first as? UIView
    }
}
