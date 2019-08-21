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
        static let baseRWURL = "https://poezd.rw.by"
        static let baseURL = "https://rasp.rw.by/\(Locale.current.currentLanguageCode)/"
    }
    
    struct APIParameterKey {
        static let term = "term"
        static let train = "train"
        static let thread = "thread"
        static let trainNumber = "train_number"
        static let from = "from"
        static let to = "to"
        static let date = "date"
        static let fromExp = "from_exp"
        static let fromEsr = "from_esr"
        static let toExp = "to_exp"
        static let toEsr = "to_esr"
        static let station = "station"
        static let carType = "car_type"
    }
    
    struct APIParseConstant {
        static let TRAIN_ID = "small[class=train_id]"
        static let PATH = "a[class=train_text]"
        static let TRAIN_TYPE = "div[class=train_description]"
        static let TIME_END = "b[class=train_end-time]"
        static let TIME_START = "b[class=train_start-time]"
        static let TRAVEL_TIME = "span[class=train_time-total]"
        static let DAYS = "td[class=train_item train_days regional_only hidden]"
        static let DAYS_VERSION_2 = "td[class=train_item train_halts]"
        static let STOPS_EXCEPT_VERSION_2 = "td[class=train_item train_days]"
        static let STOPSEXCEPT = "td[class=train_item train_halts regional_only everyday_regional_only hidden]"
        static let URL = "div[class=train_name -map]"
        static let URL_VERSION_2 = "div[class=train_name]"
        static let URL_VERSION_3 = "div[class=train_inner]"
        static let PLACE = "ul[class=train_details-group]"
        static let ELECTRONIC_REGISTRATION = "i[class=b-spec spec_reserved]"
        static let FAVOURITE_TRAIN = "i[class=b-spec spec_comfort]"
        static let FAST_TRAIN = "i[class=b-spec spec_speed]"
        static let STATION = "a[class=train_name -map train_text]"
        static let ARRIVAL = "b[class=train_end-time]"
        static let DEPARTURE = "b[class=train_start-time]"
        static let STAY = "b[class=train_stop-time]"
        static let ERROR = "div[class=error_content]"
        static let ERROR_TITLE = "div[class=error_title]"
    }
}
