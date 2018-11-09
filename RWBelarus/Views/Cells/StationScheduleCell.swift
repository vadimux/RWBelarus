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
        trainTypeLabel.text = route.trainType.rawValue
        trainRouteLabel.text = route.routeName
        
        if let finishTime = route.finishTime {
            arrivalTimeLabel.text = "Прибытие: ".localized + finishTime
        } else {
            arrivalTimeLabel.text = nil
        }
        
        if let startTime = route.startTime {
             departureTimeLabel.text = "Отправление: ".localized + startTime
        } else {
            departureTimeLabel.text = nil
        }
        if let days = route.days {
            daysLabel.text = "Дни курсирования: ".localized + days
        } else {
            daysLabel.text = nil
        }
        if let stops = route.exceptStops {
            stopsLabel.text = "Остановки: ".localized + stops
        } else {
            stopsLabel.text = nil
        }
        
        trainTypeImage.image = {
            switch route.trainType {
            case .internationalLines:
                return R.image.international()
            case .regionalEconomyLines:
                return R.image.region()
            case .regionalBusinessLines:
                return R.image.regionBusiness()
            case .interregionalEconomyLines:
                return R.image.interregionalEconomy()
            case .interregionalBusinessLines:
                return R.image.interregionalBusiness()
            case .cityLines:
                return R.image.city()
            default:
                return nil
            }
        }()
        
        model = route
    }
    
    @objc private func tappedInCell(recognizer: UITapGestureRecognizer?) {
        tapped?(model)
    }
}
