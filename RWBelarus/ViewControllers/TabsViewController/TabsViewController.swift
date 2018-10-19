//
//  TabsViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

protocol TabsViewControllerDelegate: class {
    func willShowViewController(viewController: UIViewController)
}

protocol TabsViewControllerNavigation: class {
    
}

class TabsViewController: UITabBarController {
    
    weak var controllerDelegate: TabsViewControllerDelegate?
    var coordinator: TabsViewControllerNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension TabsViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        controllerDelegate?.willShowViewController(viewController: viewController)
    }
}
