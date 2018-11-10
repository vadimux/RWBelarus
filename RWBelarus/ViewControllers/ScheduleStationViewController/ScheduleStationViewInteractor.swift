//
//  ScheduleStationViewInteractor.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/8/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class ScheduleStationViewInteractor: ScheduleStationViewControllerInteractor {
    
    var fromData: AutocompleteAPIElement?
    
    func getSchedule(for station: String, date: String, completion: @escaping (_ route: [Route]?, _ error: String?) -> Void) {
        NetworkManager.getScheduleByStation(station: station, date: date) { result in
            switch result {
            case .success(let routes):
                completion(routes, nil)
            case .failure(let error):
                if let error = error as? APIError {
                    completion(nil, error.errorText)
                    return
                }
                completion(nil, error.localizedDescription)
            }
        }
    }
}
