//
//  SearchViewInteractor.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class SearchViewInteractor: SearchViewControllerInteractor {
    
    var fromData: AutocompleteAPIElement?
    var toData: AutocompleteAPIElement?

    func convertLabelDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
    func convertSearchFormatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
}
