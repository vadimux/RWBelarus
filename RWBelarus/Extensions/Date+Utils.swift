//
//  Date+Utils.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/9/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

extension Date {
    
    static let LABEL_DATE_FORMAT = "E, d MMM"
    static let COMMON_DATE_FORMAT = "yyyy-MM-dd"
    
    static func format(date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.string(from: date)
    }
}
