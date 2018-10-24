//
//  RouteResultCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/17/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit

class RouteResultViewCoordinator: Coordinator, RouteResultViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var fromData: AutocompleteAPIElement
    var toData: AutocompleteAPIElement
    
    init(rootViewController: UINavigationController, fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement) {
        self.rootViewController = rootViewController
        self.fromData = fromData
        self.toData = toData
    }
    
    func start(with completion: CoordinatorCallback?) {
        
        guard let navViewController = R.storyboard.routeResult.routeResultNavigationController(), let viewController = navViewController.topViewController as? RouteResultViewController else {
            preconditionFailure("RouteResult Storyboard should contain RouteResultNavigationController and RouteResultViewController")
        }
        
        viewController.coordinator = self
        viewController.interactor = RouteResultViewInteractor(fromData: fromData, toData: toData)
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func stop(with completion: CoordinatorCallback?) {
    }
        
}
