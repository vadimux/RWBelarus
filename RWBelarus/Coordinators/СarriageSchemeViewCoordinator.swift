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
    
    private var dialogViewController: DialogViewController?
    private var urlPath: String
    
    init(rootViewController: UINavigationController, urlPath: String) {
        self.rootViewController = rootViewController
        self.urlPath = urlPath
        super.init()
    }
    
    func start(with completion: CoordinatorCallback?) {
        
        guard let carriageSchemeViewController = R.storyboard.routeResult.carriageSchemeViewController() else {
            preconditionFailure("RouteResult Storyboard should contain CarriageSchemeViewController")
        }
        
        carriageSchemeViewController.coordinator = self
        carriageSchemeViewController.interactor = СarriageSchemeViewInteractor(urlPath: urlPath)
        
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
