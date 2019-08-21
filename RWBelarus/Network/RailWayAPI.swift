//
//  RailWayAPI.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/19/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import Moya

enum RailWayAPI {
    case autocomplete(term: String)
    case search(fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement, date: String)
    case searchFullRoute(for: Route)
    case getSchemePlaces(for: Route, carType: String)
    case getScheduleByStation(station: String, date: String)
}

extension RailWayAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: K.RWServer.baseURL)!
    }
    
    var path: String {
        switch self {
        case .autocomplete:
            return "ajax/autocomplete/search/"
        case .search:
            return "route/"
        case .getSchemePlaces:
            return "ajax/route/car_places/"
        case .searchFullRoute:
            return "train/"
        case .getScheduleByStation:
            return "station/"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        return URLEncoding.queryString
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .autocomplete(let term):
            return .requestParameters(parameters: [K.APIParameterKey.term: term], encoding: parameterEncoding)
        case .search(let from, let to, let date):
            return .requestParameters(parameters: [K.APIParameterKey.from: from.value ?? "", K.APIParameterKey.to: to.value ?? "", K.APIParameterKey.date: date,
                                                   K.APIParameterKey.fromExp: from.exp ?? "", K.APIParameterKey.fromEsr: from.ecp ?? "", K.APIParameterKey.toExp: to.exp ?? "",
                                                   K.APIParameterKey.toEsr: to.ecp ?? ""], encoding: parameterEncoding)
        case .getSchemePlaces(let route, let carType):
            return .requestParameters(parameters: [K.APIParameterKey.trainNumber: route.trainId ?? "", K.APIParameterKey.from: route.fromExp ?? "", K.APIParameterKey.to: route.toExp ?? "", K.APIParameterKey.date: route.date ?? "", K.APIParameterKey.carType: carType], encoding: parameterEncoding)
        case .searchFullRoute(let route):
            let trainDict = (route.thread == nil) ? [K.APIParameterKey.train: route.trainId ?? ""] : [K.APIParameterKey.thread: route.thread ?? ""]
            let combinedDict = [K.APIParameterKey.fromExp: route.fromExp ?? "", K.APIParameterKey.toExp: route.toExp ?? "", K.APIParameterKey.from: route.fromStation ?? "", K.APIParameterKey.to: route.toStation ?? "", K.APIParameterKey.date: route.date ?? ""].merging(trainDict) { $1 }
            return .requestParameters(parameters: combinedDict, encoding: parameterEncoding)
        case .getScheduleByStation(let station, let date):
            return .requestParameters(parameters: [K.APIParameterKey.station: station, K.APIParameterKey.date: date], encoding: parameterEncoding)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json;charset=UTF-8"]
    }
}
