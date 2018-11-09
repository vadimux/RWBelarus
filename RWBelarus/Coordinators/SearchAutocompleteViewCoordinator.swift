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
    var tagView: Int
    
    init(rootViewController: UINavigationController, tagView: Int) {
        self.rootViewController = rootViewController
        self.tagView = tagView
    }
    
    func start(with completion: CoordinatorCallback?) {
        
        guard let viewController = R.storyboard.search.searchAutocompleteViewController() else {
            preconditionFailure("RouteResult Storyboard should contain SearchAutocompleteViewController")
        }
        
        viewController.coordinator = self
        viewController.interactor = SearchAutocompleteViewInteractor()
        viewController.searchTypeSegmentControl.isHidden = rootViewController.viewControllers.first is ScheduleStationViewController
        rootViewController.show(viewController, sender: self)
    }
    
    func stop(with completion: CoordinatorCallback?) {
    }
    
    func dismiss(vc: UIViewController, withData: AutocompleteAPIElement) {
        if let rootVC = rootViewController.viewControllers.first as? SearchViewController {
            if self.tagView == 0 {
                rootVC.interactor.fromData = withData
            } else {
                rootVC.interactor.toData = withData
            }
        }
        //FIXIT: remove this logic
        if let rootVC = rootViewController.viewControllers.first as? ScheduleStationViewController {
            rootVC.interactor.fromData = withData
        }
        _ = vc.navigationController?.popViewController(animated: false)
        vc.dismiss(animated: true)
    }
    
    func dismiss(vc: UIViewController) {
        _ = vc.navigationController?.popViewController(animated: false)
        vc.dismiss(animated: true)
    }
}
