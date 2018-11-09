//
//  Date+Utils.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/9/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

extension Date {

    static func convertLabelDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
    static func convertSearchFormatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
}
