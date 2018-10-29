//
//  FullRouteViewCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/29/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit
import Hero

class FullRouteViewCoordinator: Coordinator, FullRouteViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var route: Route
    
    init(rootViewController: UINavigationController, route: Route) {
        self.rootViewController = rootViewController
        self.route = route
    }
    
    func start(with completion: CoordinatorCallback?) {
        
        guard let viewController = R.storyboard.routeResult.fullRouteViewController() else {
            preconditionFailure("RouteResult Storyboard should contain FullRouteViewController")
        }
        
        viewController.coordinator = self
        viewController.interactor = FullRouteViewInteractor(route: route)
        rootViewController.show(viewController, sender: self)
    }
    
    func stop(with completion: CoordinatorCallback?) {
    }
    
    func dismiss(vc: UIViewController) {
        _ = vc.navigationController?.popViewController(animated: false)
        vc.dismiss(animated: true)
    }
}

