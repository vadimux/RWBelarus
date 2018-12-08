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
    
    func prepareForShowResult(completion: @escaping (_ route: [Route]?, _ error: String?) -> Void) {
        
        NetworkManager.getRouteBetweenCities(fromData: fromData, toData: toData, date: self.date) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let autocomplete):
                completion(autocomplete, nil)
            case .failure(let error):
                if let error = error as? APIError {
                    completion(nil, error.errorText)
                    return
                }
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func prepareForTitle() -> TitleInfo? {
        guard let from = fromData.value?.uppercased(), let to = toData.value?.uppercased() else { return nil }
        let title = TitleInfo(from: from, to: to, date: nil)
        return title
    }
    
    func prepareForHeaderView() -> TitleInfo? {
        guard let from = fromData.value?.uppercased(), let to = toData.value?.uppercased() else { return nil }
        
        let date: String = {
            let loc = self.date.localized
            print(loc)
            if let enumDate = RouteDate.find(self.date.localized) {
                return enumDate.value()
            }
            
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = Date.COMMON_DATE_FORMAT
            guard let date = inputDateFormatter.date(from: self.date) else {
                return ""
            }
            
            let outputDate = Date.format(date: date, dateFormat: Date.LABEL_DATE_FORMAT)
            return outputDate
        }()
        let header = TitleInfo(from: from, to: to, date: date)
        return header
    }
}

struct TitleInfo {
    
    var from: String
    var to: String
    var date: String?
}
