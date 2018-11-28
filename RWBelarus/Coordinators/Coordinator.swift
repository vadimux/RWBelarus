//
//  Coordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

/// A callback function used by coordinators to signal events.
typealias CoordinatorCallback = (Coordinator) -> Void

protocol Coordinator: class {
    
    var rootViewController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    
    /// Tells the coordinator to create its
    /// initial view controller and take over the user flow.
    func start(withCallback completion: CoordinatorCallback?)
    
    /// Tells the coordinator that it is done and that it should
    /// rewind the view controller state to where it was before `start` was called.
    func stop(withCallback completion: CoordinatorCallback?)
    
}

extension Coordinator {
    /// Add a child coordinator to the parent
    public func add(childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    /// Remove a child coordinator from the parent
    public func remove(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
    
    /// Add a child coordinator to the parent
    /// and then start the flow.
    public func add(childCoordinator: Coordinator, andStart completion: CoordinatorCallback?) {
        self.add(childCoordinator: childCoordinator)
        childCoordinator.start(withCallback: completion)
    }
    
    /// Remove a child coordinator from the parent
    /// and the end the flow.
    public func remove(childCoordinator: Coordinator, andStop completion: CoordinatorCallback?) {
        self.remove(childCoordinator: childCoordinator)
        childCoordinator.stop(withCallback: completion)
    }
}
