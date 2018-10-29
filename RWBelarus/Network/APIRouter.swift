//
//  APIRouter.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/19/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case autocomplete(term: String)
    case search(from: String, to: String, date: String, fromExp: String, fromEsr: String, toExp: String, toEsr: String)
    case searchFullRoute(trainNumber: String, fromExp: String, toExp: String, date: String)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .autocomplete, .search, .searchFullRoute:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .autocomplete:
            return "ajax/autocomplete/search/"
        case .search:
            return "route/"
        case .searchFullRoute:
            return "train/"
        }
    }
    
    // MARK: - Parameters
    private var parameters: [URLQueryItem]? {
        switch self {
        case .autocomplete(let term):
            return [URLQueryItem(name: K.APIParameterKey.term, value: term)]
        case .search(let from, let to, let date, let fromExp, let fromEsr, let toExp, let toEsr):
            return [URLQueryItem(name: K.APIParameterKey.from, value: from),
            URLQueryItem(name: K.APIParameterKey.to, value: to),
            URLQueryItem(name: K.APIParameterKey.date, value: date),
            URLQueryItem(name: K.APIParameterKey.fromExp, value: fromExp),
            URLQueryItem(name: K.APIParameterKey.fromEsr, value: fromEsr),
            URLQueryItem(name: K.APIParameterKey.toExp, value: toExp),
            URLQueryItem(name: K.APIParameterKey.toEsr, value: toEsr)]
        case .searchFullRoute(let trainNumber, let fromExp, let toExp, let date):
            return [URLQueryItem(name: K.APIParameterKey.train, value: trainNumber),
             URLQueryItem(name: K.APIParameterKey.fromExp, value: fromExp),
             URLQueryItem(name: K.APIParameterKey.toExp, value: toExp),
             URLQueryItem(name: K.APIParameterKey.date, value: date)]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        let url = try K.RWServer.baseURL.asURL()
        var urlParameters = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        
        // Parameters
        if let parameters = parameters {
            urlParameters?.queryItems = parameters
        }
        
        var urlRequest = URLRequest(url: (urlParameters?.url)!)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

        return urlRequest
    }
}
