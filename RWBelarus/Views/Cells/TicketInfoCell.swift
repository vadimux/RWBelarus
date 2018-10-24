//
//  TicketInfoCell.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/22/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class TicketInfoCell: UITableViewCell {
    
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        type.text = nil
        priceLabel.text = nil
        countLabel.text = nil
    }
    
    func configure(with placeInfo: TrainPlace) {
        type.text = placeInfo.name
        priceLabel.text = placeInfo.cost
        countLabel.text = placeInfo.count
    }

}
