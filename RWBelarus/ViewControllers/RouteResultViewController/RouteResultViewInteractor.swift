//
//  RouteResultInteractor.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/17/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class RouteResultViewInteractor: RouteResultViewControllerInteractor {
    
    private var fromData: AutocompleteAPIElement
    private var toData: AutocompleteAPIElement
    private var date: String
    
    init(fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement, date: String) {
        self.fromData = fromData
        self.toData = toData
        self.date = date
    }
    
    func prepareForShowResult(completion: @escaping (_ route: [Route]?,_ error: String?) -> ()) {
        
        NetworkManager.getRouteBetweenCities(from: fromData.value ?? "", to: toData.value ?? "", date: self.date, fromExp: fromData.exp ?? "", fromEsr: fromData.ecp ?? "", toExp: toData.exp ?? "", toEsr: toData.ecp ?? "") { result in
            switch result {
            case .success(let autocomplete):
                completion(autocomplete, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func prepareForTitle() -> String {
        guard let from = fromData.value?.uppercased(), let to = toData.value?.uppercased() else { return ""}
        return "\(from) - \(to)"
    }
    
    func prepareForHeaderView() -> (String, String, String) {
        guard let from = fromData.value?.uppercased(), let to = toData.value?.uppercased() else { return ("", "", "")}
        
        let date: String = {
            switch self.date {
            case RouteDate.today.rawValue:
                return RouteDate.today.value
            case RouteDate.tomorrow.rawValue:
                return RouteDate.tomorrow.value
            case RouteDate.everyday.rawValue:
                return RouteDate.everyday.value
            default:
                let inputDateFormatter = DateFormatter()
                inputDateFormatter.dateFormat = "yyyy-MM-dd"
                guard let date = inputDateFormatter.date(from: self.date) else {
                    return ""
                }

                let outputDate = convertLabelDate(date: date)
                return outputDate
            }
        }()
        
        return (from, to, date)
    }
    
    private func convertLabelDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
}
