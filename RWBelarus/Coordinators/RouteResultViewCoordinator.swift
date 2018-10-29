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
    var date: String
    
    init(rootViewController: UINavigationController, fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement, date: String) {
        self.rootViewController = rootViewController
        self.fromData = fromData
        self.toData = toData
        self.date = date
    }
    
    func start(with completion: CoordinatorCallback?) {
        
        guard let navViewController = R.storyboard.routeResult.routeResultNavigationController(), let viewController = navViewController.topViewController as? RouteResultViewController else {
            preconditionFailure("RouteResult Storyboard should contain RouteResultNavigationController and RouteResultViewController")
        }
        
        viewController.coordinator = self
        viewController.interactor = RouteResultViewInteractor(fromData: fromData, toData: toData, date: date)
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func stop(with completion: CoordinatorCallback?) {
    }
    
    func showFullRoute(vc: UIViewController, for route: Route) {
        guard let navVC = vc.navigationController else { return }
        let fullRouteViewCoordinator = FullRouteViewCoordinator(rootViewController: navVC, route: route)
        fullRouteViewCoordinator.start(with: nil)
    }
        
}
