//
//  SettingsCell.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/19/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var settingTypeLabel: UILabel!
    
    var tapped: ((Int) -> Void)?
    var index: Int!
    
    private var tapRecognizer: UITapGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedInCell))
        tapRecognizer?.numberOfTapsRequired = 1
        tapRecognizer?.numberOfTouchesRequired = 1
        tapRecognizer?.delegate = self
        if let aRecognizer = tapRecognizer {
            addGestureRecognizer(aRecognizer)
        }
    }
    
    func configureWith(text: String, index: Int) {
        self.settingTypeLabel?.text = text
        self.index = index
    }
    
    @objc private func tappedInCell(recognizer: UITapGestureRecognizer?) {
        tapped?(index)
    }
}
