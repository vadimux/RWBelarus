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
    lazy var presentingViewController: UIViewController = self.createFullRouteViewController()
    weak var delegate: FinishCoordinatorDelegate?
    var route: Route
    
    init(rootViewController: UINavigationController, route: Route) {
        self.rootViewController = rootViewController
        self.route = route
    }
    
    func start(withCallback completion: CoordinatorCallback?) {
        self.rootViewController.show(presentingViewController, sender: self)
        completion?(self)
    }
    
    func stop(withCallback completion: CoordinatorCallback?) {
        self.rootViewController.popViewController(animated: false)
        self.presentingViewController.dismiss(animated: true, completion: nil)
        completion?(self)
    }
    
    func dismiss() {
        self.delegate?.finishedFlow(coordinator: self)
    }
}

extension FullRouteViewCoordinator {
    
    func createFullRouteViewController() -> FullRouteViewController {
        guard let viewController = R.storyboard.routeResult.fullRouteViewController() else {
            preconditionFailure("RouteResult Storyboard should contain FullRouteViewController")
        }
        
        viewController.coordinator = self
        viewController.interactor = FullRouteViewInteractor(route: route)
        
        return viewController
    }
}
