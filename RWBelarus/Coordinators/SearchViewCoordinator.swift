//
//  SearchViewCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit

class SearchViewCoordinator: Coordinator, SearchViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start(with completion: CoordinatorCallback?) {

    }
    
    func stop(with completion: CoordinatorCallback?) {
    
    }
    
    func showResult(vc: UIViewController, from: AutocompleteAPIElement?, to: AutocompleteAPIElement?) {
        
        vc.navigationController?.navigationBar.topItem?.title = "Назад к поиску"
        
        let routeResultViewCoordinator = RouteResultViewCoordinator(rootViewController: vc.navigationController!, fromData: from, toData: to)
        routeResultViewCoordinator.start(with: nil)
    }
    
    func showStation(vc: UIViewController) {
        
//        vc.navigationController?.navigationBar.topItem?.title = "Назад к поиску"
//        rootViewController.hero.navigationAnimationType = .fade

        let searchAutocompleteViewCoordinator = SearchAutocompleteViewCoordinator(rootViewController: vc.navigationController!)
        searchAutocompleteViewCoordinator.start(with: nil)
    }
    
}

