//
//  HeaderResultCell.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/3/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class HeaderResultCell: UITableViewCell {
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        fromLabel.text = nil
        toLabel.text = nil
        dateLabel.text = nil
    }

    func configure(with info: (String, String, String)) {
        self.fromLabel.text = info.0
        self.toLabel.text = info.1
        self.dateLabel.text = info.2
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
    
    }
}
