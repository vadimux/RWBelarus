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
    
    func showResult(vc: UIViewController, from: AutocompleteAPIElement, to: AutocompleteAPIElement) {
        guard let navVC = vc.navigationController else { return }
        let routeResultViewCoordinator = RouteResultViewCoordinator(rootViewController: navVC, fromData: from, toData: to)
        routeResultViewCoordinator.start(with: nil)
    }
    
    func showStationsList(vc: UIViewController, for tagView: Int?) {
        guard let tagView = tagView, let navVC = vc.navigationController else { return }
        let searchAutocompleteViewCoordinator = SearchAutocompleteViewCoordinator(rootViewController: navVC, tagView: tagView)
        searchAutocompleteViewCoordinator.start(with: nil)
    }
    
    func showCalendar(currentDate: Date, completion: @escaping (Date) -> Void) {
        let config = CalendarConfig.init(title: "Выберите день".localized, multiSelectionAvailable: false, begin: currentDate)
        let coordinator = CalendarViewCoordinator.init(rootViewController: self.rootViewController, config: config)
        coordinator.periodSelectionActionHandler = { beginDate, endDate in
            completion(beginDate ?? Date())
        }
        coordinator.start(with: nil)
    }
    
}

