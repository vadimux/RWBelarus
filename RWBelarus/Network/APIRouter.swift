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
    case getScheduleByStation(station: String?, date: String?)
    case getLoginCredentials()
    case getAuthCredentials(url: String)
    case login(login: String?, password: String?, url: String)
    case orders()
    case pastOrders()
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .autocomplete, .search, .searchFullRoute, .getSchemePlaces, .getScheduleByStation, .orders, .getLoginCredentials, .getAuthCredentials:
            return .get
        case .login, .pastOrders:
            return .post
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
        case .getScheduleByStation:
            return "station/"
        case .getLoginCredentials:
            return "wps/portal/home/rp"
        case .orders:
            return "wps/myportal/home/rp/private/"
        case .getAuthCredentials, .login, .pastOrders:
            return ""

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
        case .searchFullRoute, .getSchemePlaces:
            return nil
        case .getScheduleByStation(let station, let date):
            return [URLQueryItem(name: K.APIParameterKey.station, value: station),
            URLQueryItem(name: K.APIParameterKey.date, value: date)]
        case .login, .orders, .pastOrders, .getLoginCredentials, .getAuthCredentials:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .getLoginCredentials:
            return try configureFirstEnterRequest()
        case .getAuthCredentials(let url):
            return try configureAuthRequest(url: url)
        case .login(let login, let password, let url):
            return try configureLoginRequest(login: login, password: password, url: url)
        case .orders:
            return try configureOrdersRequest()
        case .pastOrders:
            return try configurePastOrdersRequest()
        default:
            return try configureRequest()
        }
    }
    
    private func configureRequest() throws -> URLRequest {
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
    
    private func configureFirstEnterRequest() throws -> URLRequest {
        let url = try K.RWServer.baseRWURL.asURL()
        let urlParameters = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true)

        var urlRequest = URLRequest(url: (urlParameters?.url)!)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.url.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        return urlRequest
    }
    
    private func configureAuthRequest(url: String) throws -> URLRequest {
        let url = try url.asURL()
        let urlParameters = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        var urlRequest = URLRequest(url: (urlParameters?.url)!)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.url.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        return urlRequest
    }
    
    private func configureLoginRequest(login: String?, password: String?, url: String) throws -> URLRequest {
        let url = try url.asURL()
        let urlParameters = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        
        let requestInfo = "login=\(login ?? "")&password=\(password ?? "")&_rememberUser=on&ip=178.168.144.17&_login=%D0%92%D0%BE%D0%B9%D1%82%D0%B8+%D0%B2+%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%83"

        var urlRequest = URLRequest(url: (urlParameters?.url)!)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = requestInfo.data(using: .utf8)
        
        // Common Headers
        urlRequest.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.url.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        return urlRequest
    }
    
    private func configureOrdersRequest() throws -> URLRequest {
        let url = try K.RWServer.baseRWURL.asURL()
        let urlParameters = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        var urlRequest = URLRequest(url: (urlParameters?.url)!)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        return urlRequest
    }
    
    private func configurePastOrdersRequest() throws -> URLRequest {
        let url = try K.RWServer.basePastOrdersURL.asURL()
        let urlParameters = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        var urlRequest = URLRequest(url: (urlParameters?.url)!)
        let requestInfo = "javax.faces.encodedURL=p0%2FIZ7_9HD6HG80NGMO80ABJ9NPD12GG4%3DCZ6_9HD6HG80NGMO80ABJ9NPD120O3%3DNJrwCabinetView.xhtml%3D%2F&viewns_Z7_9HD6HG80NGMO80ABJ9NPD12GG4_%3Amenu_SUBMIT=1&javax.faces.ViewState=OZ6mna3SxmX7HXspJuDSwxcHH%2FpFEIh1s9B06atD5xOplneb63fz00yxbe2LYZzyzrmm6YxhyZVsBMSiR3s%2FOFkCVdpue4zT4ZDGTsKvBKEQ89TS9VwqNea%2FPQWMnGyybiSfhSHyKXv5XPIpJcYCa4yUz%2BY9twYoedDbshimxVWQs0VXEsoX6ipWMQU05cSny5uOw%2FP9zMPJv%2F%2BHFE5LSH8REtMq0IgtXoy3qr5UGTYY5hTkHIZkdeVByhfPsEBdfM3wInuM5ixF1is0LZnali1QDTGQ2%2B4RNCvD9rB21WZ%2FwLwz58nBTCwBEG3wCWufm1VdswJg%2FjYO35HeglO7ntKgBDTAjOLDOdP6EzFNOuAkxWQmEyXWzqLoN4VNjNQC5HkgZd2pgfZ51YsxkfmnNkXwJJ8fZCROj9yrodlFaE0NgzcFeFXpsS80bRWIcfzpHJNDLXjcdrgNf%2FHT8aIH%2FWrCQkAOp%2FR3%2Bk%2BE%2F%2FWXM%2F8qIquAVKrH40WcT6fm8qGPZckn3uunB%2BGDyJ2Hr6kjzjIf2Gp2XKNZWH5vBaydy1myUJnuoBrV7NkcscxBwD45dBN%2BA%2BZ5K5%2FvLNCsp5zq1il5vUHxce19qpN0h%2BgyTHTZtA43T5VsLyRxh4tMeuMfI1qAccleM%2BfZEZIXviFmSYgOeBP44c4eOVVoJo9g6ATo13NAsEdsKx2IHll62qB2ifOd9afHcB%2F4%2Fm3z0CwccgIgpujVp3cWJ6cMa8GfEc7pvtjtMEh1sPnOxtpIVK8DUCgkfUfRSME1OJygG1Kwgfc8ycZg8I%2BaasJCQA6n9Hf6T4T%2F9Zcz%2Fyoiq4BUqsfjVZ6tk2rp80rEKkpWGtLyuiskJlptNvD0zzTVfnZD2hTVA1KmpN5oE7YqjvzoZ5ueWYQ9dfx67DNaFrVCrIHKEBv86EkCcWoLek3LQ3EUOHr%2BZOmJzYhcgPL%2BOqFHz2ZWiQZ2d7lbdYY%2FpfjVhS%2FB4Y7H%2BMIGn%2BOcds4UJHxCib4ss3DUreCF%2Fp7bb5hqnr4A6ub8JsvBL6Ql%2F2Kmsc%2FSyWUC9xNqndw%2BG%2FzoSQJxagsAXKtlRMwOiUE%2BMqkhvfsVpYU8HtjS1Jv4CanR4LbS4jkJJTVovCobDWj4S7lw0OYWK%2BC2AUw94%2FIhHaJ8j5MHu2JX8mfT4tPPm3uwppLGtbtiV%2FJn0%2BLTK5xKS%2BueRsmmCDK4qhAXr9P39QUnXa3vCIG%2F61hEQKl4EagIUdyNrwiVE8X8y4U5nY34WPiXOD2dchojy1lhDZBp6IeUmCSk4XULw0NthW3hdrpoEtb2ZjOIqElSD5R41HcsIynwbgln1GbBCJlS5IGM50LT26WEmxgcGj1CxFKwh9FnLkJgz5cxVu9RDH9GBPVtzVaed05LT6Px0xJKng7kb8pIU%2F2cBfSNPgIKAT8S%2BN1Vpuipt0BkwiyxJYbD%2Bfv3Rnknswtj5w36eA0UVRoTaSyabON9wV%2BepW6GH9UhrCZiHRZGZZhWcT0JIRsGJ9LE5%2BXUHHLkzrwdrSQKSl1TGcolXkOt2NC0UScyEvWWndJVR5CLa1LS%2BoVgqge9OOPTfh%2FUlw5Ry8PejRc1Q9jQtFEnMhL1lp3SVUeQi2tinUSV5QalJtXlTEYVxUU0UcvD3o0XNUNAZMIssSWGw6UNVfjZv2tLwDHuwtecWYcNVwzl09RjqWQ0rtUCmQawxnckbAchOKBcVjSs%2F6spNKDUAIBPoI1bZVqSeGmBtHAXOHFDrYU6ETA7EBNah1HAjGx3tgALIaRR40p%2ByCg4sY16ojnOLB7OU3yxd9ZZLXXxfTZOPc%2B8wf6NFl9fVeUExdruJULe57FaCcrfaWvOmBQ7%2Fg8PlJN2Bo%2FQjcG5bhnDrXybnZumxIWzNvTPBAYxXTeHvoMn7JIOJcty58GAqFcmZivFIN0pwwJUKIIlrMBjEPTdxX8F6kdUMbOkTX2Xj%2F%2FwrhKALnwJBjdZDr4JdArp8wCgvQ1A%2B2Hd2QVAvpdaFgVpplnL5KPyRiSKl2CL1Y%2B9ocze7VBNZhUdTfs85pv8T6lGKiV7R%2FcAa0ZTpRA%2BdCvG6gv2dqrWLawwqWG8OwxSgx3pVJACaZL5kW1sK%2Bj6qRRffCj4BBu9AzK0erz0yCDSraoX%2FkCgOgJbFPseWZh0lo6a0Hz1FEYr8ouF58BYWWqxo3N4HrPtGaREXyuEzD3kHX%2FqSoC1eG4V0tvfc4JO9nMM8nqaAcxZSUBfY6rB6%2FBr5QS%2Fz6YNBldwP3tSUsh98EDjlKFyl2AanzR%2FeIK5I7ASEnzY71P%2BMSfdm8VwDCdf3%2FUk6Sx3%2FVcRvpH4Wwb3cDxOXRm4tkbR8kC7zMkHN2yXDRXwTesG6yBgna86R25IpugmU4g5h%2BXlvfY%2BwRsRS55oYDylX6L0QFa6IA0xZBZepqmbDH8BxNxFNRLM1Qf6MPADAIcMd76WIhhpLTqqBpW0eDPcjvrAwyNHDoL2MDNJVo3ie1fKWZmYp1Zh1ldfYDSNKyQmWm028PR%2BC0ASSBXS3o35uliZw8NEMy7kpUWcEXPjn7nErHlYVRF7ryFRPJsHZ1qCJLg9prL3dscVpoZQZwGDa3mI19a2VfIhW1z6rODu7CQt3wriPeJ7V8pZmZinVmHWV19gNI0rJCZabTbw9H4LQBJIFdLejfm6WJnDw0QzLuSlRZwRc%2BOfucSseVhVEXuvIVE8mwdnWoIkuD2msvd2xxWmhlBnkhl6IJnABkmXB8qO0kPu7tEjCrKviXz14ntXylmZmKdWYdZXX2A0jSskJlptNvD0fgtAEkgV0t5cCfCEN53QkzMu5KVFnBFz45%2B5xKx5WFURe68hUTybB2dagiS4Paay93bHFaaGUGe97DPDL9eX35%2F2NvuKD%2FKBWHhS6wgU8BIbHf1uZMAS%2BWS08RO2u7%2FncM8AnyML3odQwvfwxUnFlUOiH1DvAHwHBiGwhtbR2hNcsvs22qw%2BYg6MFdxlwjpwL5B22sVcEAPhDgyjoIbP6gJz0WHIb%2FxEXeKuG5Ca03o4km5FWb1dUHnVizGR%2Bac26Los%2B6akeu3uA8xaLrelXVJSyH3wQOOUoXKXYBqfNH94grkjsBISfNjvU%2F4xJ92bTJtbdYa7o0Sp3yewkfZOL3g8MAkVheZgntJAFOz9aGkZuLZG0fJAu8zJBzdslw0V8E3rBusgYJ2vOkduSKboJlOIOYfl5b32%2BWruZaMctjE8pV%2Bi9EBWuiANMWQWXqapmwx%2FAcTcRTUSzNUH%2BjDwA%2Fzg62MQjJK3owI6e5fzJfdO82NNkiwWYMQqSlYa0vK6KyQmWm028PQ%2FEAJTDR07xQTsm%2FXQdETvV1v%2Bm5AaXNKeRyW8LQ4z8fICYxDp82e0pk6chG6wjuFssafik%2B3wkt13A5g52AmDTmlDy0VPxEGNOTfwdwe%2F1HXXSaG8ga7gyIxjE7hv%2BV%2F32113rCrHArMnekOBqyb5u5GfyCGt9h4aCdJWYPrMwnFrb%2B5%2B95R3cycB8Bmylm8odSmyT9W6Y5oxZ%2BaSNF3462kgny2VQ3APBYaWiZXs3XlJRxBOByDdxJuZYRc8JvF7eyrPj52%2FLT8OkYW64%2BCic4JO9nMM8nodpOS%2Bt8HHlp%2F45v4rhk%2BeX2Gs5uEHP%2BpndKkOODv5OamcPxI%3D&viewns_Z7_9HD6HG80NGMO80ABJ9NPD12GG4_%3Amenu%3A_idcl=viewns_Z7_9HD6HG80NGMO80ABJ9NPD12GG4_%3Amenu%3Ans_Z7_9HD6HG80NGMO80ABJ9NPD12GG4_j_id567138984_532736b3"
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = requestInfo.data(using: .utf8)
        
        // Common Headers
        urlRequest.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        return urlRequest
    }
}
