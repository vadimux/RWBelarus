//
//  Coordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

public typealias CoordinatorCallback = (Coordinator) -> Void

/// The Coordinator protocol
public protocol Coordinator: class {
    
    var rootViewController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    
    func start(with completion: CoordinatorCallback?)   // starts this concrete coordinator
    func stop(with completion: CoordinatorCallback?)    // stops this concrete coordinator
    func startChild(coordinator: Coordinator, completion: CoordinatorCallback?) //starts child from this coordinator
    func stopChild(coordinator: Coordinator, completion: CoordinatorCallback?)  //stops child in this coordinator
    
}

public extension Coordinator {
    
    func startChild(coordinator: Coordinator, completion: CoordinatorCallback?) {
        childCoordinators.append(coordinator)
        coordinator.start(with: completion)
    }
    
    func stopChild(coordinator: Coordinator, completion: CoordinatorCallback?) {
        let index = childCoordinators.index { $0 === coordinator }
        guard let childIndex = index else { return }
        
        coordinator.stop { (coordinator) in
            self.childCoordinators.remove(at: childIndex)
            completion?(coordinator)
        }
    }
}

extension Coordinator {
    
    static func appCoordinator() -> AppCoordinator? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.coordinator
        } else {
            return nil
        }
    }
    
    func appCoordinator() -> AppCoordinator? {
        return Self.appCoordinator()
    }
    
}
