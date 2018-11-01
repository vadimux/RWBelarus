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
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        arrivalTimeLabel.text = nil
        departureTimeLabel.text = nil
        stayTimeLabel.text = nil
        stationNameLabel.text = nil
    }
    
    func configure(with station: RouteItem, isBottomLineHidden: Bool, isTopLineViewHidden: Bool) {
        
        arrivalTimeLabel.text = station.arrival
        departureTimeLabel.text = station.departure
        stayTimeLabel.text = station.stay
        stationNameLabel.text = station.station
        topLineView.isHidden = isTopLineViewHidden
        bottomLineView.isHidden = isBottomLineHidden
    }
    
    
}
