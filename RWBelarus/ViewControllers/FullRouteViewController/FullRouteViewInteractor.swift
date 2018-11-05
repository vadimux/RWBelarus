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
    
    var route: Route
    
    init(route: Route) {
        self.route = route
    }
    
    func fetchFullRoute(completion: @escaping (_ stations: [RouteItem]?, _ error: String?) -> Void) {
        
        NetworkManager.getFullRoute(for: self.route) { result in
            switch result {
            case .success(let stations):
                completion(stations, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func prepareForTitle() -> String {
        guard let from = route.fromStation?.uppercased(), let to = route.toStation?.uppercased() else { return ""}
        return "\(from) - \(to)"
    }
}
