//
//  RouteItem.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/29/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class RouteItem {
    var station: String?
    var arrival: String?
    var departure: String?
    var travelTime: String?
    var stay: String?
    var stationId: String?
}

extension RouteItem {
    class Builder {
        
        private var station: String?
        private var arrival: String?
        private var departure: String?
        private var travelTime: String?
        private var stay: String?
        var stationId: String?
        
        init(routeItemObject: RouteItem? = nil) {
            if let routeItemObject = routeItemObject {
                station = routeItemObject.station
                arrival = routeItemObject.arrival
                departure = routeItemObject.departure
                travelTime = routeItemObject.travelTime
                stay = routeItemObject.stay
                stationId = routeItemObject.stationId
            }
        }
        
        func station(_ station: String?) -> Builder {
            self.station = station
            return self
        }
        
        func stationId(_ stationId: String?) -> Builder {
            self.stationId = stationId
            return self
        }
        
        func arrival(_ arrival: String?) -> Builder {
            self.arrival = arrival == "" ? nil : arrival
            return self
        }
        
        func departure(_ departure: String?) -> Builder {
            self.departure = departure == "" ? nil : departure
            return self
        }
        
        func travelTime(_ travelTime: String?) -> Builder {
            self.travelTime = travelTime == "" ? nil : travelTime
            return self
        }
        
        func stay(_ stay: String?) -> Builder {
            self.stay = stay == "" ? nil : stay
            return self
        }
        
        func build() -> RouteItem {
            
            let routeItemObject = RouteItem()
            
            if let station = station {
                routeItemObject.station = station
            }
            if let arrival = arrival {
                routeItemObject.arrival = arrival
            }
            if let departure = departure {
                routeItemObject.departure = departure
            }
            if let travelTime = travelTime {
                routeItemObject.travelTime = travelTime
            }
            if let stay = stay {
                routeItemObject.stay = stay
            }
            if let stationId = stationId {
                routeItemObject.stationId = stationId
            }
            return routeItemObject
        }
    }
    
    static func create() -> Builder {
        return Builder()
    }
}
