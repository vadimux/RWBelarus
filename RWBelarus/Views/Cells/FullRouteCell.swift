//
//  FullRouteCell.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/30/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class FullRouteCell: UITableViewCell {
    
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var stayTimeLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        arrivalTimeLabel.text = nil
        departureTimeLabel.text = nil
        stayTimeLabel.text = nil
        stationNameLabel.text = nil
    }
    
    func configure(with station: RouteItem) {
        
        arrivalTimeLabel.text = station.arrival == "" ? nil : station.arrival
        departureTimeLabel.text = station.departure == "" ? nil : station.departure
        stayTimeLabel.text = station.stay == "" ? nil : station.stay
        stationNameLabel.text = station.station == "" ? nil : station.station
        
        print(stayTimeLabel.text)
        print(departureTimeLabel.text)
        print(arrivalTimeLabel.text)
    }
    
    
}
