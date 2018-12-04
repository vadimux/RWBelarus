//
//  LoginViewInteractor.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class LoginViewInteractor: LoginViewControllerInteractor {
    
    func loginWith(_ login: String, password: String, completion: @escaping (_ result: String?, _ error: String?) -> Void) {
//        NetworkManager.login(with: login, password: password) { result in
//            switch result {
//            case .success(let result):
//                completion(result, nil)
//            case .failure(let error):
//                if let error = error as? APIError {
//                    completion(nil, error.errorText)
//                    return
//                }
//                completion(nil, error.localizedDescription)
//            }
//        }
    }
}
