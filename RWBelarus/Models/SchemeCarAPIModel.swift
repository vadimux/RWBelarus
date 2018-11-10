//
//  SchemeCarAPIModel.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/3/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class SchemeCarAPIModel: Codable {
    let isSimplePopup: Bool?
    let carType, trainNumber, trainType: String?
    let isFastTrain: Bool?
    let from, to, fromCode, toCode: String?
    let route: RouteAPIModel?
    let hideCarImage, allowOrder: Bool?
    let tariffs: [Tariff]?
    
    enum CodingKeys: String, CodingKey {
        case isSimplePopup, carType, trainNumber, trainType, isFastTrain, from, to, fromCode, toCode, route, hideCarImage
        case allowOrder = "allow_order"
        case tariffs
    }
    
    init(isSimplePopup: Bool?, carType: String?, trainNumber: String?, trainType: String?, isFastTrain: Bool?, from: String?, to: String?, fromCode: String?, toCode: String?, route: RouteAPIModel?, hideCarImage: Bool?, allowOrder: Bool?, tariffs: [Tariff]?) {
        self.isSimplePopup = isSimplePopup
        self.carType = carType
        self.trainNumber = trainNumber
        self.trainType = trainType
        self.isFastTrain = isFastTrain
        self.from = from
        self.to = to
        self.fromCode = fromCode
        self.toCode = toCode
        self.route = route
        self.hideCarImage = hideCarImage
        self.allowOrder = allowOrder
        self.tariffs = tariffs
    }
}

class RouteAPIModel: Codable {
    let from, to, startDate, startDateForRequest: String?
    let startTime, endDate, endTime, timeInWay: String?
    let startDateFormatted: String?
    let hidden: Bool?
    
    init(from: String?, to: String?, startDate: String?, startDateForRequest: String?, startTime: String?, endDate: String?, endTime: String?, timeInWay: String?, startDateFormatted: String?, hidden: Bool?) {
        self.from = from
        self.to = to
        self.startDate = startDate
        self.startDateForRequest = startDateForRequest
        self.startTime = startTime
        self.endDate = endDate
        self.endTime = endTime
        self.timeInWay = timeInWay
        self.startDateFormatted = startDateFormatted
        self.hidden = hidden
    }
}

class Tariff: Codable {
    let price, typeAbbr, typeAbbrPostfix: String?
    let isBicycle: Bool?
    let type, typeAbbrInt: String?
    let description: String?
    let sign: String?
    let isCarForDisabled: Bool?
    let priceByn: String?
    let cars: [Car]?
    
    enum CodingKeys: String, CodingKey {
        case price, typeAbbr, typeAbbrPostfix, isBicycle, type, typeAbbrInt, description, sign
        case isCarForDisabled = "is_car_for_disabled"
        case priceByn = "price_byn"
        case cars
    }
    
    init(price: String?, typeAbbr: String?, typeAbbrPostfix: String?, isBicycle: Bool?, type: String?, typeAbbrInt: String?, description: String?, sign: String?, isCarForDisabled: Bool?, priceByn: String?, cars: [Car]?) {
        self.price = price
        self.typeAbbr = typeAbbr
        self.typeAbbrPostfix = typeAbbrPostfix
        self.isBicycle = isBicycle
        self.type = type
        self.typeAbbrInt = typeAbbrInt
        self.description = description
        self.sign = sign
        self.isCarForDisabled = isCarForDisabled
        self.priceByn = priceByn
        self.cars = cars
    }
}

class Car: Codable {
    let number, carrier, owner, upperPlaces: String?
    let upperSidePlaces, lowerPlaces, lowerSidePlaces: String?
    let totalPlaces: Int?
    let totalPlacesHide: Bool?
    let emptyPlaces: [String]?
    let hideLegend: Bool?
    let imgSrc, hash: String?
    let noSmoking: Bool?
    
    init(number: String?, carrier: String?, owner: String?, upperPlaces: String?, upperSidePlaces: String?, lowerPlaces: String?, lowerSidePlaces: String?, totalPlaces: Int?, totalPlacesHide: Bool?, emptyPlaces: [String]?, hideLegend: Bool?, imgSrc: String?, hash: String?, noSmoking: Bool?) {
        self.number = number
        self.carrier = carrier
        self.owner = owner
        self.upperPlaces = upperPlaces
        self.upperSidePlaces = upperSidePlaces
        self.lowerPlaces = lowerPlaces
        self.lowerSidePlaces = lowerSidePlaces
        self.totalPlaces = totalPlaces
        self.totalPlacesHide = totalPlacesHide
        self.emptyPlaces = emptyPlaces
        self.hideLegend = hideLegend
        self.imgSrc = imgSrc
        self.hash = hash
        self.noSmoking = noSmoking
    }
}

//class SchemeCarAPIModel: Codable {
//    let isSimplePopup: Bool
//    let carType, trainNumber, trainType: String
//    let isFastTrain: Bool
//    let from, to, fromCode, toCode: String
//    let route: RouteAPIModel
//    let hideCarImage, allowOrder: Bool
//    let tariffs: [Tariff]
//
//    enum CodingKeys: String, CodingKey {
//        case isSimplePopup, carType, trainNumber, trainType, isFastTrain, from, to, fromCode, toCode, route, hideCarImage
//        case allowOrder = "allow_order"
//        case tariffs
//    }
//
//    init(isSimplePopup: Bool, carType: String, trainNumber: String, trainType: String, isFastTrain: Bool, from: String, to: String, fromCode: String, toCode: String, route: RouteAPIModel, hideCarImage: Bool, allowOrder: Bool, tariffs: [Tariff]) {
//        self.isSimplePopup = isSimplePopup
//        self.carType = carType
//        self.trainNumber = trainNumber
//        self.trainType = trainType
//        self.isFastTrain = isFastTrain
//        self.from = from
//        self.to = to
//        self.fromCode = fromCode
//        self.toCode = toCode
//        self.route = route
//        self.hideCarImage = hideCarImage
//        self.allowOrder = allowOrder
//        self.tariffs = tariffs
//    }
//}
//
//class RouteAPIModel: Codable {
//    let from, to, startDate, startDateForRequest: String
//    let startTime, endDate, endTime, timeInWay: String
//    let startDateFormatted: String
//    let hidden: Bool
//
//    init(from: String, to: String, startDate: String, startDateForRequest: String, startTime: String, endDate: String, endTime: String, timeInWay: String, startDateFormatted: String, hidden: Bool) {
//        self.from = from
//        self.to = to
//        self.startDate = startDate
//        self.startDateForRequest = startDateForRequest
//        self.startTime = startTime
//        self.endDate = endDate
//        self.endTime = endTime
//        self.timeInWay = timeInWay
//        self.startDateFormatted = startDateFormatted
//        self.hidden = hidden
//    }
//}
//
//class Tariff: Codable {
//    let price, typeAbbr, typeAbbrPostfix: String
//    let isBicycle: Bool
//    let type, typeAbbrInt, description, sign: String
//    let isCarForDisabled: Bool
//    let priceByn: String
//    let cars: [Car]
//
//    enum CodingKeys: String, CodingKey {
//        case price, typeAbbr, typeAbbrPostfix, isBicycle, type, typeAbbrInt, description, sign
//        case isCarForDisabled = "is_car_for_disabled"
//        case priceByn = "price_byn"
//        case cars
//    }
//
//    init(price: String, typeAbbr: String, typeAbbrPostfix: String, isBicycle: Bool, type: String, typeAbbrInt: String, description: String, sign: String, isCarForDisabled: Bool, priceByn: String, cars: [Car]) {
//        self.price = price
//        self.typeAbbr = typeAbbr
//        self.typeAbbrPostfix = typeAbbrPostfix
//        self.isBicycle = isBicycle
//        self.type = type
//        self.typeAbbrInt = typeAbbrInt
//        self.description = description
//        self.sign = sign
//        self.isCarForDisabled = isCarForDisabled
//        self.priceByn = priceByn
//        self.cars = cars
//    }
//}
//
//class Car: Codable {
//    let number, carrier, owner, upperPlaces: String
//    let upperSidePlaces, lowerPlaces, lowerSidePlaces: String
//    let totalPlaces: Int
//    let totalPlacesHide: Bool
//    let emptyPlaces: [String]
//    let hideLegend: Bool
//    let imgSrc, hash: String
//    let noSmoking: Bool
//
//    init(number: String, carrier: String, owner: String, upperPlaces: String, upperSidePlaces: String, lowerPlaces: String, lowerSidePlaces: String, totalPlaces: Int, totalPlacesHide: Bool, emptyPlaces: [String], hideLegend: Bool, imgSrc: String, hash: String, noSmoking: Bool) {
//        self.number = number
//        self.carrier = carrier
//        self.owner = owner
//        self.upperPlaces = upperPlaces
//        self.upperSidePlaces = upperSidePlaces
//        self.lowerPlaces = lowerPlaces
//        self.lowerSidePlaces = lowerSidePlaces
//        self.totalPlaces = totalPlaces
//        self.totalPlacesHide = totalPlacesHide
//        self.emptyPlaces = emptyPlaces
//        self.hideLegend = hideLegend
//        self.imgSrc = imgSrc
//        self.hash = hash
//        self.noSmoking = noSmoking
//    }
//}
