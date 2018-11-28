//
//  UIImage+TrainType.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 12/3/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func configureImage(for trainType: TrainType) -> UIImage? {
        switch trainType {
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
    }
}
