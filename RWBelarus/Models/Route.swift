//
//  Route.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

enum TrainType: String {
    case internationalLines = "Международные линии"
    case regionalEconomyLines = "Региональные линии экономкласса"
    case regionalBusinessLines = "Региональные линии бизнес-класса"
    case interregionalEconomyLines = "Межрегиональные линии экономкласса"
    case interregionalBusinessLines = "Межрегиональные линии бизнес-класса"
    case cityLines = "Городские линии"
    case unknown = ""
}

class Route {
    let trainId: String?
    let travelTime: String?
    let startTime: String?
    let finishTime: String?
    let routeName: String?
    let days: String?
    let trainType: TrainType
    let exceptStops: String?
    let place: [TrainPlace]?
    
    init(trainId: String?, travelTime: String?, startTime: String?, finishTime: String?, routeName: String?, days: String?, trainType: String?, exceptStops: String?, place: [TrainPlace]?) {
        self.trainId = trainId
        self.travelTime = travelTime
        self.startTime = startTime
        self.finishTime = finishTime
        self.routeName = routeName
        self.days = days
        self.trainType = TrainType(rawValue: trainType ?? "") ?? .unknown
        self.exceptStops = exceptStops
        self.place = place
    }
}
