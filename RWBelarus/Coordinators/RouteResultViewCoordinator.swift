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
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UINavigationController
    lazy var presentingViewController: UIViewController = self.createRouteResultViewController()
    var fromData: AutocompleteAPIElement
    var toData: AutocompleteAPIElement
    var date: String
    weak var delegate: FinishCoordinatorDelegate?
    
    init(rootViewController: UINavigationController, fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement, date: String) {
        self.rootViewController = rootViewController
        self.fromData = fromData
        self.toData = toData
        self.date = date
    }
    
    func start(withCallback completion: CoordinatorCallback?) {
        self.rootViewController.pushViewController(self.presentingViewController, animated: true)
        completion?(self)
    }
    
    func stop(withCallback completion: CoordinatorCallback?) {
        self.rootViewController.popViewController(animated: false)
        completion?(self)
    }
    
    func showFullRoute(for route: Route) {
        guard let navVC = presentingViewController.navigationController else { return }
        let fullRouteViewCoordinator = FullRouteViewCoordinator(rootViewController: navVC, route: route)
        fullRouteViewCoordinator.delegate = self
        self.add(childCoordinator: fullRouteViewCoordinator, andStart: nil)
    }
    
    func dismiss() {
        self.delegate?.finishedFlow(coordinator: self)
    }
    
}

extension RouteResultViewCoordinator {
    
    func createRouteResultViewController() -> RouteResultViewController {
        guard let navViewController = R.storyboard.routeResult.routeResultNavigationController(), let viewController = navViewController.topViewController as? RouteResultViewController else {
            preconditionFailure("RouteResult Storyboard should contain RouteResultNavigationController and RouteResultViewController")
        }
        
        viewController.coordinator = self
        viewController.interactor = RouteResultViewInteractor(fromData: fromData, toData: toData, date: date)
        
        return viewController
    }
}

extension RouteResultViewCoordinator: FinishCoordinatorDelegate {
    func finishedFlow(coordinator: Coordinator) {
        self.remove(childCoordinator: coordinator)
    }
}
