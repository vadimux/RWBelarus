//
//  CalendarViewCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/26/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit

struct CalendarConfig {
    let title: String?
    let minimumAvailableDate: Date?
    let maximumAvailableDate: Date?
    let beginDate: Date?
    let endDate: Date?
    
    let isMultiSelectionAvailable: Bool
    
    init(title: String? = nil, multiSelectionAvailable: Bool = false, begin: Date? = nil, end: Date? = nil, min: Date? = nil, max: Date? = nil) {
        self.title = title
        self.beginDate = begin
        self.endDate = end
        self.minimumAvailableDate = min
        self.maximumAvailableDate = max
        self.isMultiSelectionAvailable = multiSelectionAvailable
    }
}

class CalendarViewCoordinator: NSObject, Coordinator, CalendarViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    private var dialogViewController: DialogViewController?
    
    var periodSelectionActionHandler : ((_ beginDate: Date?, _ endDate: Date?) -> Void)?
    
    private let config: CalendarConfig
    
    var childCoordinators: [Coordinator] = []
    
    init(rootViewController: UINavigationController, config: CalendarConfig?) {
        self.rootViewController = rootViewController
        self.config = config ?? CalendarConfig()
        super.init()
    }
    
    func start(with completion: CoordinatorCallback?) {
        
        guard let calendarViewController = R.storyboard.search.calendarViewController() else {
            preconditionFailure("Search Storyboard should contain CalendarViewController")
        }
        
        calendarViewController.coordinator = self
        calendarViewController.interactor = CalendarViewInteractor.init(config: config)
        
        dialogViewController = DialogViewController.init(rootViewController: calendarViewController)
        rootViewController.present(dialogViewController!, animated: true) {
            completion?(self)
        }
    }
    
    func stop(with completion: CoordinatorCallback?) {
        dialogViewController?.dismiss(animated: true, completion: {
            completion?(self)
        })
    }
    
    func title() -> String? {
        return config.title
    }
    
    func applyPeriodFromDate(_ beginDate: Date?, endDate: Date?) {
        periodSelectionActionHandler?(beginDate, endDate)
    }
    
}
