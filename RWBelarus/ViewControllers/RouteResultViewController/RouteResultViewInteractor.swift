//
//  RouteResultInteractor.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/17/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class RouteResultViewInteractor: RouteResultViewControllerInteractor {
    
    var fromData: AutocompleteAPIElement?
    var toData: AutocompleteAPIElement?
    
    init(fromData: AutocompleteAPIElement?, toData: AutocompleteAPIElement?) {
        self.fromData = fromData
        self.toData = toData
    }
    
    func prepareForShowResult(completion: @escaping (_ route: [Route]?,_ error: String?) -> ()) {
        
        NetworkManager.getRouteBetweenCities(from: fromData?.value ?? "", to: toData?.value ?? "", date: "everyday", fromExp: fromData?.exp ?? "", fromEsr: fromData?.ecp ?? "", toExp: toData?.exp ?? "", toEsr: toData?.ecp ?? "") { result in
            switch result {
            case .success(let autocomplete):
                completion(autocomplete, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
