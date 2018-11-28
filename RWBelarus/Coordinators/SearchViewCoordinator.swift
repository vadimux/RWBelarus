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
    
    var childCoordinators: [Coordinator]
    var rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        childCoordinators = []
    }
    
    func start(withCallback completion: CoordinatorCallback?) {
        completion?(self)
    }
    
    func stop(withCallback completion: CoordinatorCallback?) {
        self.rootViewController.dismiss(animated: true) {
            completion?(self)
        }
    }
    
    func showResult(vc: UIViewController, from: AutocompleteAPIElement, to: AutocompleteAPIElement, date: String) {
        guard let navVC = vc.navigationController else { return }
        let routeResultViewCoordinator = RouteResultViewCoordinator(rootViewController: navVC, fromData: from, toData: to, date: date)
        routeResultViewCoordinator.delegate = self
        self.add(childCoordinator: routeResultViewCoordinator, andStart: nil)
    }
    
    func showStationsList(vc: UIViewController, for typeView: DirectionViewType?) {
        guard let typeView = typeView, let navVC = vc.navigationController else { return }
        let searchAutocompleteViewCoordinator = SearchAutocompleteViewCoordinator(rootViewController: navVC, typeView: typeView)
        searchAutocompleteViewCoordinator.delegate = self
        self.add(childCoordinator: searchAutocompleteViewCoordinator, andStart: nil)
    }
    
    func showCalendar(currentDate: Date, completion: @escaping (Date) -> Void) {
        let config = CalendarConfig.init(title: "Выберите день".localized, multiSelectionAvailable: false, begin: currentDate)
        let calendarViewCoordinator = CalendarViewCoordinator.init(rootViewController: self.rootViewController, config: config)
        calendarViewCoordinator.periodSelectionActionHandler = { beginDate, endDate in
            completion(beginDate ?? Date())
        }
        calendarViewCoordinator.delegate = self
        self.add(childCoordinator: calendarViewCoordinator, andStart: nil)
    }
}

extension SearchViewCoordinator: FinishCoordinatorDelegate {
    func finishedFlow(coordinator: Coordinator) {
        self.remove(childCoordinator: coordinator, andStop: nil)
    }
}
