//
//  СarriageSchemeViewCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/4/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//
import Foundation
import UIKit

class СarriageSchemeViewCoordinator: NSObject, Coordinator, СarriageSchemeViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    lazy var presentingViewController: UIViewController = self.createCarriageSchemeViewController()
    weak var delegate: FinishCoordinatorDelegate?
    private var dialogViewController: DialogViewController?
    private var route: Route
    private var carType: String
    
    init(rootViewController: UINavigationController, route: Route, carType: String) {
        self.rootViewController = rootViewController
        self.route = route
        self.carType = carType
    }
    
    func start(withCallback completion: CoordinatorCallback?) {
        dialogViewController = DialogViewController.init(rootViewController: presentingViewController)
        rootViewController.present(dialogViewController!, animated: true) {
            completion?(self)
        }
    }
    
    func stop(withCallback completion: CoordinatorCallback?) {
        dialogViewController?.dismiss(animated: true, completion: {
            completion?(self)
        })
    }
    
    func dismiss() {
        self.delegate?.finishedFlow(coordinator: self)
    }
}

extension СarriageSchemeViewCoordinator {
    
    func createCarriageSchemeViewController() -> CarriageSchemeViewController {
        guard let carriageSchemeViewController = R.storyboard.routeResult.carriageSchemeViewController() else {
            preconditionFailure("RouteResult Storyboard should contain CarriageSchemeViewController")
        }
        
        carriageSchemeViewController.coordinator = self
        carriageSchemeViewController.interactor = СarriageSchemeViewInteractor(route: self.route, carType: self.carType)
        
        return carriageSchemeViewController
    }
}
