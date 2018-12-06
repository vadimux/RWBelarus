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

protocol FinishCoordinatorDelegate: class {
    func finishedFlow(coordinator: Coordinator)
}

class SearchAutocompleteViewCoordinator: Coordinator, SearchAutocompleteViewControllerCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UINavigationController
    lazy var presentingViewController: UIViewController = self.createSearchAutocompleteViewController()
    var typeView: DirectionViewType
    
    weak var delegate: FinishCoordinatorDelegate?
    
    init(rootViewController: UINavigationController, typeView: DirectionViewType) {
        self.rootViewController = rootViewController
        self.typeView = typeView
    }
    
    func start(withCallback completion: CoordinatorCallback?) {
        self.rootViewController.pushViewController(presentingViewController, animated: false)
        presentingViewController.navigationItem.hidesBackButton = true
        completion?(self)
    }
    
    func stop(withCallback completion: CoordinatorCallback?) {
        self.rootViewController.popViewController(animated: false)
        completion?(self)
    }
    
    func dismiss(withData: AutocompleteAPIElement) {
        if let rootVC = rootViewController.viewControllers.first as? SearchViewController {
            if self.typeView == .fromView {
                rootVC.interactor.fromData = withData
            } else {
                rootVC.interactor.toData = withData
            }
        }
        //FIXIT: remove this logic
        if let rootVC = rootViewController.viewControllers.first as? ScheduleStationViewController {
            rootVC.interactor.fromData = withData
        }
        self.delegate?.finishedFlow(coordinator: self)
    }
    
    func dismiss(fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement) {
        if let rootVC = rootViewController.viewControllers.first as? SearchViewController {
            rootVC.interactor.fromData = fromData
            rootVC.interactor.toData = toData
        }
        self.delegate?.finishedFlow(coordinator: self)
    }
    
    func dismiss() {
        self.delegate?.finishedFlow(coordinator: self)
    }
}

extension SearchAutocompleteViewCoordinator {
    
    func createSearchAutocompleteViewController() -> SearchAutocompleteViewController {
        guard let viewController = R.storyboard.search.searchAutocompleteViewController() else {
            preconditionFailure("RouteResult Storyboard should contain SearchAutocompleteViewController")
        }
        viewController.interactor = SearchAutocompleteViewInteractor()
        viewController.coordinator = self
        
        return viewController
    }
}
