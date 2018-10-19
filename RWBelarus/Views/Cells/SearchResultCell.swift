//
//  SearchResultCell.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/17/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var trainNumberLabel: UILabel!
    @IBOutlet weak var trainRouteLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var finishTime: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    
    private var tapRecognizer: UITapGestureRecognizer?
    var tapped: ((Route) -> Void)?
    var model: Route!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trainNumberLabel.text = nil
        trainRouteLabel.text = nil
        startTimeLabel.text = nil
        durationLabel.text = nil
        finishTime.text = nil
        daysLabel.text = nil
    }
    
    func configure(with element: Route) {
        
        trainNumberLabel.text = element.trainId
        trainRouteLabel.text = element.routeName
        startTimeLabel.text = element.startTime
        durationLabel.text = element.travelTime
        finishTime.text = element.finishTime
        daysLabel.text = element.days
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedInCell))
        tapRecognizer?.numberOfTapsRequired = 1
        tapRecognizer?.numberOfTouchesRequired = 1
        tapRecognizer?.delegate = self
        if let aRecognizer = tapRecognizer {
            addGestureRecognizer(aRecognizer)
        }
        model = element
    }
    
    @objc private func tappedInCell(recognizer: UITapGestureRecognizer?) {
        tapped?(model)
    }
}
