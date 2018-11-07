//
//  File.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/3/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class СarriageSchemeViewInteractor: СarriageSchemeViewControllerInteractor {
    
    private var urlPath: String
    
    init(urlPath: String) {
        self.urlPath = urlPath
    }
    
    func fetchСarriageScheme(completion: @escaping (_ information: SchemeCarAPIModel?, _ error: String?) -> Void) {
        
        NetworkManager.getSchemePlaces(with: self.urlPath) { result in
            switch result {
            case .success(let information):
                completion(information, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
