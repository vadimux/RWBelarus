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
    case search(fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement, date: String)
    case searchFullRoute(urlPath: String?)
    case getSchemePlaces(urlPath: String?)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .autocomplete, .search, .searchFullRoute, .getSchemePlaces:
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
        case .searchFullRoute(let urlPath):
            guard let urlPath = urlPath else {
                return ""
            }
            //TODO: fix it with locale of device
            let path = urlPath.replacingOccurrences(of: "/ru/", with: "")
            return path
        case .getSchemePlaces(let urlPath):
            guard let urlPath = urlPath else {
                return ""
            }
            //TODO: fix it with locale of device
            let path = urlPath.replacingOccurrences(of: "/ru/", with: "")
            return path
        }
    }
    
    // MARK: - Parameters
    private var parameters: [URLQueryItem]? {
        switch self {
        case .autocomplete(let term):
            return [URLQueryItem(name: K.APIParameterKey.term, value: term)]
        case .search(let from, let to, let date):
            return [URLQueryItem(name: K.APIParameterKey.from, value: from.value),
            URLQueryItem(name: K.APIParameterKey.to, value: to.value),
            URLQueryItem(name: K.APIParameterKey.date, value: date),
            URLQueryItem(name: K.APIParameterKey.fromExp, value: from.exp),
            URLQueryItem(name: K.APIParameterKey.fromEsr, value: from.ecp),
            URLQueryItem(name: K.APIParameterKey.toExp, value: to.exp),
            URLQueryItem(name: K.APIParameterKey.toEsr, value: to.ecp)]
            URLQueryItem(name: K.APIParameterKey.fromExp, value: fromExp),
            URLQueryItem(name: K.APIParameterKey.fromEsr, value: fromEsr),
            URLQueryItem(name: K.APIParameterKey.toExp, value: toExp),
            URLQueryItem(name: K.APIParameterKey.toEsr, value: toEsr)]
        case .searchFullRoute, .getSchemePlaces:
            return nil
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
