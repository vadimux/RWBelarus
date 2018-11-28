//
//  AppCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var window: UIWindow?
    lazy var rootViewController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start(withCallback completion: CoordinatorCallback?) {
        self.window?.rootViewController = self.rootViewController
        self.window?.makeKeyAndVisible()
        self.startTabsScreenCoordinator(withCallback: completion)
    }
    
    func stop(withCallback completion: CoordinatorCallback?) {
        self.window?.rootViewController = nil
        self.window?.makeKeyAndVisible()
    }
    
    func setupAppearance() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor(rgb: 0x36608A)
        UITabBar.appearance().tintColor = UIColor(rgb: 0x36608A)
        UITabBar.appearance().backgroundColor = .white
    }
    
    func startTabsScreenCoordinator(withCallback completion: CoordinatorCallback?) {
        let tabsScreenCoordinator = TabsScreenCoordinator(rootViewController: self.rootViewController)
        tabsScreenCoordinator.start(withCallback: completion)
    }
}
