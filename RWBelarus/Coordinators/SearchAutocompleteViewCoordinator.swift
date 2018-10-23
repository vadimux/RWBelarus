//
//  SearchAutocompleteViewCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/23/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit
import Hero

class SearchAutocompleteViewCoordinator: Coordinator, SearchAutocompleteViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start(with completion: CoordinatorCallback?) {
        
        guard let navViewController = R.storyboard.search.searchAutocompleteNavigationViewController(), let viewController = navViewController.topViewController as? SearchAutocompleteViewController else {
            preconditionFailure("RouteResult Storyboard should contain RouteResultNavigationController and RouteResultViewController")
        }

        viewController.coordinator = self
        viewController.interactor = SearchAutocompleteViewInteractor()
        rootViewController.show(viewController, sender: self)
    }
    
    func stop(with completion: CoordinatorCallback?) {
    }
    
}
