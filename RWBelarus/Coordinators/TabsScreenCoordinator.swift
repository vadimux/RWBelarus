//
//  TabsScreenCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class TabsScreenCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UINavigationController
    
    lazy var tabBarViewController: UITabBarController = self.createTabsViewController()
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start(withCallback completion: CoordinatorCallback?) {
        rootViewController.setViewControllers([tabBarViewController], animated: false)
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    func stop(withCallback completion: CoordinatorCallback?) {
        self.rootViewController.dismiss(animated: true) {
            completion?(self)
        }
    }
    
    private func searchViewController() -> UINavigationController {
        
        guard let navViewController = R.storyboard.search.searchNavigationController(), let viewController = navViewController.topViewController as? SearchViewController else {
            preconditionFailure("Search Storyboard should contain SearchNavigationController and SearchViewController")
        }
        
        viewController.interactor = SearchViewInteractor()
        let searchViewCoordinator = SearchViewCoordinator(rootViewController: rootViewController)
        viewController.coordinator = searchViewCoordinator
        self.add(childCoordinator: searchViewCoordinator)
        
        return navViewController
    }
    
    private func scheduleStationViewController() -> UINavigationController {

        guard let navViewController = R.storyboard.station.scheduleStationNavigationController(), let viewController = navViewController.topViewController as? ScheduleStationViewController else {
            preconditionFailure("Station Storyboard should contain ScheduleStationNavigationController and ScheduleStationViewController")
        }

        viewController.interactor = ScheduleStationViewInteractor()
        let scheduleStationViewCoordinator = ScheduleStationViewCoordinator(rootViewController: rootViewController)
        viewController.coordinator = scheduleStationViewCoordinator
        self.add(childCoordinator: scheduleStationViewCoordinator)

        return navViewController
    }
    
    private func settingsViewController() -> UINavigationController {

        guard let navViewController = R.storyboard.settings.settingsNavigationController(), let viewController = navViewController.topViewController as? SettingsViewController else {
            preconditionFailure("Settings Storyboard should contain LoginNavigationController and LoginViewController")
        }
        
        viewController.interactor = SettingsViewInteractor()
        let settingsViewCoordinator = SettingsViewCoordinator(rootViewController: rootViewController)
        viewController.coordinator = settingsViewCoordinator
        self.add(childCoordinator: settingsViewCoordinator)
        
        return navViewController
    }
}

extension TabsScreenCoordinator {
    
    func createTabsViewController() -> UITabBarController {
        guard let viewController = R.storyboard.main.tabsViewController() else {
            preconditionFailure("Main Storyboard should contain TabsViewController")
        }
        viewController.viewControllers = [searchViewController(), scheduleStationViewController(), settingsViewController()]
        return viewController
    }
}
