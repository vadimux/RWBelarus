//
//  AppCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

// The AppCoordinator is first coordinator
/// The AppCoordinator as a rootViewController
class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var childCoordinators: [Coordinator] = []
    
    lazy var rootViewController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()
    
    private var splashScreen: UIViewController?
    private(set) lazy var launchScreen: UIViewController = {
        return R.storyboard.launchScreen.instantiateInitialViewController()!
    }()
    
    /// Window to manage
    let window: UIWindow
    
    // MARK: - Init
    
    public init(window: UIWindow) {
        self.window = window
        self.window.backgroundColor = .white
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
        
        setupAppearance()
    }
    
    // MARK: - Functions
    
    func setupAppearance() {
        UINavigationBar.appearance().tintColor = .blue
        UINavigationBar.appearance().shadowImage = UIImage()
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UITabBar.appearance().tintColor = .blue
        UITabBar.appearance().backgroundColor = .white
        
        rootViewController.hero.isEnabled = true
        rootViewController.navigationBar.barTintColor = .white
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    func start(with completion: CoordinatorCallback?) {
        presentSplashScreen()
        self.startMainScreenCoordinator()
    }
    
    func stop(with completion: CoordinatorCallback?) {
        print("Can't stop root coordinator")
    }
    
    private func startMainScreenCoordinator() {
        let tabsScreenCoordinator = TabsScreenCoordinator(rootViewController: rootViewController)
        tabsScreenCoordinator.delegate = self
        hideSplashScreen()
        tabsScreenCoordinator.start(with: nil)
    }
    
    func presentSplashScreen() {
        guard splashScreen == nil, let controller = R.storyboard.launchScreen.instantiateInitialViewController() else { return }
        controller.modalPresentationStyle = .overFullScreen
        self.splashScreen = controller
        rootViewController.present(controller, animated: false) {
        }
    }
    
    func hideSplashScreen() {
        guard splashScreen != nil else { return }
        splashScreen?.dismiss(animated: false, completion: {
            self.splashScreen = nil
        })
    }
}

extension TabsScreenCoordinator {
    
}

extension TabsScreenCoordinator: TabsViewControllerDelegate {
    func willShowViewController(viewController: UIViewController) {
    }
}

extension AppCoordinator: TabsScreenCoordinatorDelegate {
    
}
