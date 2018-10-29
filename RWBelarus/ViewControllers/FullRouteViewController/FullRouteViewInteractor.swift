//
//  FullRouteViewInteractor.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/29/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import Alamofire

class FullRouteViewInteractor: FullRouteViewControllerInteractor {
    
    private var route: Route
    
    init(route: Route) {
        self.route = route
    }
    
    func fetchFullRoute(completion: @escaping (_ stations: [Route]?, _ error: String?) -> Void) {
        
        NetworkManager.getFullRoute(trainNumber: self.route.trainId, fromExp: self.route.fromExp, toExp: self.route.toExp, date: self.route.date) { result in
            switch result {
            case .success(let stations):
                completion(stations, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
