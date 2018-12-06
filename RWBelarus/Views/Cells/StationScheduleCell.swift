//
//  StationScheduleCell.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/8/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class StationScheduleCell: UITableViewCell {
    
    @IBOutlet weak var trainTypeImage: UIImageView!
    @IBOutlet weak var trainNumberLabel: UILabel!
    @IBOutlet weak var trainTypeLabel: UILabel!
    @IBOutlet weak var trainRouteLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var stopsLabel: UILabel!
    
    var tapped: ((Route) -> Void)?
    var model: Route!
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trainNumberLabel.text = nil
        trainTypeLabel.text = nil
        trainRouteLabel.text = nil
        trainTypeImage.image = nil
        arrivalTimeLabel.text = nil
        departureTimeLabel.text = nil
        daysLabel.text = nil
        stopsLabel.text = nil
    }
    
    func configure(with route: Route) {
        
        trainNumberLabel.text = route.trainId
        trainTypeLabel.text = route.trainType.localizedString()
        trainRouteLabel.text = route.routeName
        
        arrivalTimeLabel.text = route.finishTime == nil ? nil : "Прибытие: ".localized + route.finishTime!
        departureTimeLabel.text = route.startTime == nil ? nil : "Отправление: ".localized + route.startTime!
        daysLabel.text = route.days == nil ? nil: "Дни курсирования: ".localized + route.days!
        stopsLabel.text = route.exceptStops == nil ? nil : "Остановки: ".localized + route.exceptStops!
        trainTypeImage.image = UIImage.configureImage(for: route.trainType)
        
        model = route
    }
    
    @objc private func tappedInCell(recognizer: UITapGestureRecognizer?) {
        tapped?(model)
    }
}
