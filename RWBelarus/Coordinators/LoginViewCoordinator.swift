//
//  LoginViewCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit

class LoginViewCoordinator: Coordinator, LoginViewControllerCoordinator {

    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start(with completion: CoordinatorCallback?) {
        
    }
    
    func stop(with completion: CoordinatorCallback?) {
        
    }
    
    func showPersonalArea() {
    }
    
}
