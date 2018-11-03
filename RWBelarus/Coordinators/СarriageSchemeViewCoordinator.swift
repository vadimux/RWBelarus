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
    private var dialogViewController: DialogViewController?
    
    var childCoordinators: [Coordinator] = []
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        super.init()
    }
    
    func start(with completion: CoordinatorCallback?) {
        
        guard let carriageSchemeViewController = R.storyboard.routeResult.carriageSchemeViewController() else {
            preconditionFailure("RouteResult Storyboard should contain CarriageSchemeViewController")
        }
        
        carriageSchemeViewController.coordinator = self
        
        dialogViewController = DialogViewController.init(rootViewController: carriageSchemeViewController)
        rootViewController.present(dialogViewController!, animated: true) {
            completion?(self)
        }
    }
    
    func stop(with completion: CoordinatorCallback?) {
        dialogViewController?.dismiss(animated: true, completion: {
            completion?(self)
        })
    }
    
}
