//
//  ScheduleStationViewCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/8/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit

class ScheduleStationViewCoordinator: Coordinator, ScheduleStationViewControllerCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start(withCallback completion: CoordinatorCallback?) {}
    
    func stop(withCallback completion: CoordinatorCallback?) {
        self.rootViewController.dismiss(animated: true) {
            completion?(self)
        }
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
    
    func showFullRoute(vc: UIViewController, for route: Route) {
        guard let navVC = vc.navigationController else { return }
        let fullRouteViewCoordinator = FullRouteViewCoordinator(rootViewController: navVC, route: route)
        fullRouteViewCoordinator.delegate = self
        self.add(childCoordinator: fullRouteViewCoordinator, andStart: nil)
    }
}

extension ScheduleStationViewCoordinator: FinishCoordinatorDelegate {
    
    func finishedFlow(coordinator: Coordinator) {
        self.remove(childCoordinator: coordinator, andStop: nil)
    }
}
