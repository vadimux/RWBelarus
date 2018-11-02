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
    
    var trainId: String?
    var travelTime: String?
    var startTime: String?
    var finishTime: String?
    var routeName: String?
    var days: String?
    var fromExp: String?
    var toExp: String?
    var fromStation: String?
    var toStation: String?
    var date: String?
    var trainType: TrainType = .unknown
    var exceptStops: String?
    var urlPath: String?
    var place: [TrainPlace] = [TrainPlace]()
}

extension Route {
    class Builder {
        
        private var trainId: String?
        private var travelTime: String?
        private var startTime: String?
        private var finishTime: String?
        private var routeName: String?
        private var days: String?
        private var fromExp: String?
        private var toExp: String?
        private var fromStation: String?
        private var toStation: String?
        private var date: String?
        private var trainType: TrainType?
        private var exceptStops: String?
        private var urlPath: String?
        private var place: [TrainPlace]?
        
        init(routeObject: Route? = nil) {
            if let routeObject = routeObject {
                trainId = routeObject.trainId
                travelTime = routeObject.travelTime
                startTime = routeObject.startTime
                finishTime = routeObject.finishTime
                fromExp = routeObject.fromExp
                toExp = routeObject.toExp
                routeName = routeObject.routeName
                days = routeObject.days
                trainType = routeObject.trainType
                exceptStops = routeObject.exceptStops
                place = routeObject.place
                date = routeObject.date
                urlPath = routeObject.urlPath
                fromStation = routeObject.fromStation
                toStation = routeObject.toStation
            }
        }
        
        func trainId(_ trainId: String?) -> Builder {
            self.trainId = trainId
            return self
        }
        
        func fromStation(_ fromStation: String?) -> Builder {
            self.fromStation = fromStation
            return self
        }
        
        func toStation(_ toStation: String?) -> Builder {
            self.toStation = toStation
            return self
        }
        
        func travelTime(_ travelTime: String?) -> Builder {
            self.travelTime = travelTime
            return self
        }
        
        func startTime(_ startTime: String?) -> Builder {
            self.startTime = startTime
            return self
        }
        
        func finishTime(_ finishTime: String?) -> Builder {
            self.finishTime = finishTime
            return self
        }
        
        func date(_ date: String?) -> Builder {
            self.date = date
            return self
        }
        
        func routeName(_ routeName: String?) -> Builder {
            self.routeName = routeName
            return self
        }
        
        func fromExp(_ fromExp: String?) -> Builder {
            self.fromExp = fromExp
            return self
        }
        
        func toExp(_ toExp: String?) -> Builder {
            self.toExp = toExp
            return self
        }
        
        func days(_ days: String?) -> Builder {
            self.days = days
            return self
        }
        
        func trainType(_ trainType: TrainType) -> Builder {
            self.trainType = trainType
            return self
        }
        
        func exceptStops(_ exceptStops: String?) -> Builder {
            self.exceptStops = exceptStops
            return self
        }
        
        func place(_ place: [TrainPlace]) -> Builder {
            self.place = place
            return self
        }
        
        func urlPath(_ urlPath: String?) -> Builder {
            self.urlPath = urlPath
            return self
        }
        
        func build() -> Route {
            
            let routeObject = Route()
            
            if let trainId = trainId {
                routeObject.trainId = trainId
            }
            if let travelTime = travelTime {
                routeObject.travelTime = travelTime
            }
            if let startTime = startTime {
                routeObject.startTime = startTime
            }
            if let finishTime = finishTime {
                routeObject.finishTime = finishTime
            }
            if let routeName = routeName {
                routeObject.routeName = routeName
            }
            if let toExp = toExp {
                routeObject.toExp = toExp
            }
            if let date = date {
                routeObject.date = date
            }
            if let urlPath = urlPath {
                routeObject.urlPath = urlPath
            }
            if let fromExp = fromExp {
                routeObject.fromExp = fromExp
            }
            if let days = days {
                routeObject.days = days
            }
            if let trainType = trainType {
                routeObject.trainType = trainType
            }
            if let exceptStops = exceptStops {
                routeObject.exceptStops = exceptStops
            }
            if let place = place {
                routeObject.place = place
            }
            if let fromStation = fromStation {
                routeObject.fromStation = fromStation
            }
            if let toStation = toStation {
                routeObject.toStation = toStation
            }
            
            return routeObject
        }
    }

    static func create() -> Builder {
        return Builder()
    }
}
