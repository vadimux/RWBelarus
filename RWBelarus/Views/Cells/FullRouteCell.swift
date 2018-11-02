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
    @IBOutlet weak var roundView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        arrivalTimeLabel.text = nil
        departureTimeLabel.text = nil
        stayTimeLabel.text = nil
        stationNameLabel.text = nil
        topLineView.backgroundColor = nil
        bottomLineView.backgroundColor = nil
        roundView.backgroundColor = nil
    }
    
    func configure(with station: RouteItem, isBottomLineHidden: Bool, isTopLineViewHidden: Bool, route: Route) {
        
        arrivalTimeLabel.text = station.arrival
        departureTimeLabel.text = station.departure
        stayTimeLabel.text = station.stay
        stationNameLabel.text = station.station
        topLineView.isHidden = isTopLineViewHidden
        bottomLineView.isHidden = isBottomLineHidden
        
        if route.trainType != .cityLines && route.trainType != .regionalEconomyLines {
            if let station = station.station, let fromStation = route.fromStation, let toStation = route.toStation, !station.containsIgnoringCase(find: fromStation) && !station.containsIgnoringCase(find: toStation) {
                topLineView.backgroundColor = .gray
                bottomLineView.backgroundColor = .gray
                roundView.backgroundColor = .gray
            } else {
                addColor()
            }
        } else {
            addColor()
        }
    }
    
    private func addColor() {
        topLineView.backgroundColor = UIColor(rgb: 0x025C91)
        bottomLineView.backgroundColor = UIColor(rgb: 0x025C91)
        roundView.backgroundColor = UIColor(rgb: 0x025C91)
    }
    
}

extension String {
    func contains(find: String) -> Bool {
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
