//
//  Constants.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/19/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

struct K {
    struct RWServer {
        static let baseURL = "https://rasp.rw.by/ru/"
//        static let baseURL = "https://rasp.rw.by/\(Locale.current.currentLanguageCode)/"
    }
    
    struct APIParameterKey {
        static let term = "term"
        static let train = "train"
        static let from = "from"
        static let to = "to"
        static let date = "date"
        static let fromExp = "from_exp"
        static let fromEsr = "from_esr"
        static let toExp = "to_exp"
        static let toEsr = "to_esr"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json;charset=UTF-8"
}
