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
    let hideCarImage: Bool?
    let route: RouteAPIModel?
    let isElRegPossible, allowOrder: Bool?
    let tariffs: [Tariff]?
    
    enum CodingKeys: String, CodingKey {
        case isSimplePopup, carType, trainNumber, trainType, isFastTrain, from, to, fromCode, toCode, hideCarImage, route, isElRegPossible
        case allowOrder
        case tariffs
    }
    
    init(isSimplePopup: Bool?, carType: String?, trainNumber: String?, trainType: String?, isFastTrain: Bool?, from: String?, to: String?, fromCode: String?, toCode: String?, hideCarImage: Bool?, route: RouteAPIModel?, isElRegPossible: Bool?, allowOrder: Bool?, tariffs: [Tariff]?) {
        self.isSimplePopup = isSimplePopup
        self.carType = carType
        self.trainNumber = trainNumber
        self.trainType = trainType
        self.isFastTrain = isFastTrain
        self.from = from
        self.to = to
        self.fromCode = fromCode
        self.toCode = toCode
        self.hideCarImage = hideCarImage
        self.route = route
        self.isElRegPossible = isElRegPossible
        self.allowOrder = allowOrder
        self.tariffs = tariffs
    }
}

// MARK: - Route
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

// MARK: - Tariff
class Tariff: Codable {
    let price, priceByn, price2, priceByn2: String?
    let typeAbbr, typeAbbrPostfix: String?
    let isBicycle: Bool?
    let type, typeAbbrInt, tariffDescription, sign: String?
    let isCarForDisabled, isElRegPossible: Bool?
    let cars: [Car]?
    
    enum CodingKeys: String, CodingKey {
        case price
        case priceByn
        case price2
        case priceByn2
        case typeAbbr, typeAbbrPostfix, isBicycle, type, typeAbbrInt
        case tariffDescription
        case sign
        case isCarForDisabled
        case isElRegPossible, cars
    }
    
    init(price: String?, priceByn: String?, price2: String?, priceByn2: String?, typeAbbr: String?, typeAbbrPostfix: String?, isBicycle: Bool?, type: String?, typeAbbrInt: String?, tariffDescription: String?, sign: String?, isCarForDisabled: Bool?, isElRegPossible: Bool?, cars: [Car]?) {
        self.price = price
        self.priceByn = priceByn
        self.price2 = price2
        self.priceByn2 = priceByn2
        self.typeAbbr = typeAbbr
        self.typeAbbrPostfix = typeAbbrPostfix
        self.isBicycle = isBicycle
        self.type = type
        self.typeAbbrInt = typeAbbrInt
        self.tariffDescription = tariffDescription
        self.sign = sign
        self.isCarForDisabled = isCarForDisabled
        self.isElRegPossible = isElRegPossible
        self.cars = cars
    }
}

// MARK: - Car
class Car: Codable {
    let number, subType, carrier, owner: String?
    let emptyPlaces: [String]?
    let hideLegend: Bool?
    let imgSrc, hash: String?
    let noSmoking, ticketSellingAllowed: Bool?
    let addSigns: String?
    let saleOnTwo: Bool?
    let trainLetter, classServiceInt, typeShow: String?
    let isElRegPossible: Bool?
    let upperPlaces, upperSidePlaces, lowerPlaces, lowerSidePlaces: Int?
    let totalPlacesHide: Bool?
    let totalPlaces: Int?
    
    enum CodingKeys: String, CodingKey {
        case number, subType, carrier, owner, emptyPlaces, hideLegend, imgSrc, hash, noSmoking
        case ticketSellingAllowed
        case addSigns, saleOnTwo, trainLetter, classServiceInt, typeShow, isElRegPossible, upperPlaces, upperSidePlaces, lowerPlaces, lowerSidePlaces, totalPlacesHide, totalPlaces
    }
    
    init(number: String?, subType: String?, carrier: String?, owner: String?, emptyPlaces: [String]?, hideLegend: Bool?, imgSrc: String?, hash: String?, noSmoking: Bool?, ticketSellingAllowed: Bool?, addSigns: String?, saleOnTwo: Bool?, trainLetter: String?, classServiceInt: String?, typeShow: String?, isElRegPossible: Bool?, upperPlaces: Int?, upperSidePlaces: Int?, lowerPlaces: Int?, lowerSidePlaces: Int?, totalPlacesHide: Bool?, totalPlaces: Int?) {
        self.number = number
        self.subType = subType
        self.carrier = carrier
        self.owner = owner
        self.emptyPlaces = emptyPlaces
        self.hideLegend = hideLegend
        self.imgSrc = imgSrc
        self.hash = hash
        self.noSmoking = noSmoking
        self.ticketSellingAllowed = ticketSellingAllowed
        self.addSigns = addSigns
        self.saleOnTwo = saleOnTwo
        self.trainLetter = trainLetter
        self.classServiceInt = classServiceInt
        self.typeShow = typeShow
        self.isElRegPossible = isElRegPossible
        self.upperPlaces = upperPlaces
        self.upperSidePlaces = upperSidePlaces
        self.lowerPlaces = lowerPlaces
        self.lowerSidePlaces = lowerSidePlaces
        self.totalPlacesHide = totalPlacesHide
        self.totalPlaces = totalPlaces
    }
}
