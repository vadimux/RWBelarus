//
//  TabsScreenCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

protocol TabsScreenCoordinatorDelegate: class {
}


class TabsScreenCoordinator: NSObject, Coordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: TabsScreenCoordinatorDelegate?
    weak var tabBarController: UITabBarController?
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        super.init()
    }
    
    func start(with completion: CoordinatorCallback?) {
        
        guard let viewController = R.storyboard.main.tabsViewController() else {
            preconditionFailure("Main Storyboard should contain TabsViewController")
        }
        
        viewController.viewControllers = [searchViewController()]
        viewController.coordinator = self
        
        tabBarController = viewController
        
        rootViewController.setViewControllers([viewController], animated: false)
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    func stop(with completion: CoordinatorCallback?) {
    }
    
    private func searchViewController() -> UINavigationController {
        
        guard let navViewController = R.storyboard.search.searchNavigationController(), let viewController = navViewController.topViewController as? SearchViewController else {
            preconditionFailure("Search Storyboard should contain SearchNavigationController and SearchViewController")
        }
        navViewController.delegate = self
        viewController.interactor = SearchViewInteractor()
        viewController.coordinator = SearchViewCoordinator(rootViewController: rootViewController)
        
        return navViewController
    }
}

extension TabsScreenCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
}

extension TabsScreenCoordinator: TabsViewControllerNavigation {
    
}
