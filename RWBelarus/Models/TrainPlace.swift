//
//  TrainPlace.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/22/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class TrainPlace {
    
    var name: String = ""
    var count: String = ""
    var carType: String = ""
    var cost: String = ""
}

extension TrainPlace {
    class Builder {
        private var name: String?
        private var count: String?
        private var carType: String?
        private var cost: String?
        
        init(trainPlaceObject: TrainPlace? = nil) {
            if let trainPlaceObject = trainPlaceObject {
                name = trainPlaceObject.name
                count = trainPlaceObject.count
                carType = trainPlaceObject.carType
                cost = trainPlaceObject.cost
            }
        }
        
        func name(_ name: String) -> Builder {
            self.name = name
            return self
        }
        
        func count(_ count: String) -> Builder {
            self.count = count
            return self
        }
        
        func carType(_ carType: String) -> Builder {
            self.carType = carType
            return self
        }
        
        func cost(_ cost: String) -> Builder {
            self.cost = cost
            return self
        }
        
        func build() -> TrainPlace {
            
            let trainPlaceObject = TrainPlace()
            
            if let name = name {
                trainPlaceObject.name = name
            }
            if let count = count {
                trainPlaceObject.count = count
            }
            if let carType = carType {
                trainPlaceObject.carType = carType
            }
            if let cost = cost {
                trainPlaceObject.cost = cost
            }

            return trainPlaceObject
        }
    }

    static func create() -> Builder {
        return Builder()
    }
}
