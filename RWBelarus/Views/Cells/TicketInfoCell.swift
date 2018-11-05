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
    
    var tapped: ((String?) -> Void)?
    var link: String?
    private var tapRecognizer: UITapGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedInTicketView))
        tapRecognizer?.numberOfTapsRequired = 1
        tapRecognizer?.numberOfTouchesRequired = 1
        tapRecognizer?.delegate = self
        if let aRecognizer = tapRecognizer {
            addGestureRecognizer(aRecognizer)
        }
    }
    
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
        link = placeInfo.link
    }

    @objc private func tappedInTicketView(recognizer: UITapGestureRecognizer?) {
        tapped?(link)
    }
}
