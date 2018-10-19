//
//  TrainRoute.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class TrainRoute {
    let trainId: String
    let travelTime: String
    
    init(trainId: String, travelTime: String) {
        self.trainId = trainId
        self.travelTime = travelTime
    }
}
