//
//  Route.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class Route {
    let trainId: String
    let travelTime: String
    let startTime: String
    let finishTime: String
    let routeName: String
    let days: String
    
    init(trainId: String, travelTime: String, startTime: String, finishTime: String, routeName: String, days: String) {
        self.trainId = trainId
        self.travelTime = travelTime
        self.startTime = startTime
        self.finishTime = finishTime
        self.routeName = routeName
        self.days = days
    }
}
