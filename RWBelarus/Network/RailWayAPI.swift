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
    case searchFullRoute(urlPath: String?)
    case getSchemePlaces(urlPath: String?)
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
        case .searchFullRoute(let urlPath), .getSchemePlaces(let urlPath):
            guard let urlPath = urlPath else {
                return ""
            }
            let path = urlPath.replacingOccurrences(of: "/\(Locale.current.currentLanguageCode)/", with: "")
            return path
        case .getScheduleByStation:
            return "station/"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .autocomplete(let term):
            return .requestParameters(parameters: [K.APIParameterKey.term: term], encoding: URLEncoding.queryString)
        case .search(let from, let to, let date):
            return .requestParameters(parameters: [K.APIParameterKey.from: from.value ?? "", K.APIParameterKey.to: to.value ?? "", K.APIParameterKey.date: date,
                                                   K.APIParameterKey.fromExp: from.exp ?? "", K.APIParameterKey.fromEsr: from.ecp ?? "", K.APIParameterKey.toExp: to.exp ?? "",
                                                   K.APIParameterKey.toEsr: to.ecp ?? ""], encoding: URLEncoding.queryString)
        case .searchFullRoute, .getSchemePlaces:
            return .requestPlain
        case .getScheduleByStation(let station, let date):
            return .requestParameters(parameters: [K.APIParameterKey.station: station, K.APIParameterKey.date: date], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/xml;charset=UTF-8", "X-AppId": "7b5973ab1e88e23476579bae7916d768"]
    }
}
