//
//  FullRouteViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/29/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

protocol FullRouteViewControllerInteractor: class {
//    func prepareForTitle() -> String
    func fetchFullRoute(completion: @escaping (_ stations: [Route]?, _ error: String?) -> Void)
}

protocol FullRouteViewControllerCoordinator: class {
    
}

class FullRouteViewController: UIViewController {
    
    var interactor: FullRouteViewControllerInteractor!
    var coordinator: FullRouteViewControllerCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.fetchFullRoute { result, error in
            
        }
    }
    
}
