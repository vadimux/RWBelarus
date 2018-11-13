//
//  CarriageSchemeCell.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/4/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit
import Kingfisher

class CarriageSchemeCell: UITableViewCell {
    
    @IBOutlet weak var carriageImageView: UIImageView!
    @IBOutlet weak var carriageNumberLabel: UILabel!
    @IBOutlet weak var countEmptyPlacesLabel: UILabel!
    @IBOutlet weak var emptyPlacesLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        carriageNumberLabel.text = nil
        countEmptyPlacesLabel.text = nil
        emptyPlacesLabel.text = nil
        carriageImageView.image = nil
    }
    
    func configure(with info: Car) {
        carriageNumberLabel.text = "Номер вагона: ".localized + (info.number ?? "")
        if let totalPlaces = info.totalPlaces {
            countEmptyPlacesLabel.text = "Свободных мест: ".localized + String(totalPlaces)
        }
        emptyPlacesLabel.text = "Номера свободных мест: ".localized  + (info.emptyPlaces?.joined(separator: ", ") ?? "")
        
        if let localURL = info.imgSrc, localURL != "" {
            //FIXIT: change 'ru' to '..'
            let baseURL = K.RWServer.baseURL.replacingOccurrences(of: "ru/", with: "")
            let url = URL(string: "\(baseURL)\(localURL)")
            carriageImageView.kf.setImage(with: url)
        } else {
            carriageImageView.isHidden = true
        }
    }
}
