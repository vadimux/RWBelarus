//
//  СarriageSchemeViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/3/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

protocol СarriageSchemeViewControllerInteractor: class {

}

protocol СarriageSchemeViewControllerCoordinator: class {
    
}

class CarriageSchemeViewController: UIViewController {
    
    var interactor: СarriageSchemeViewControllerInteractor!
    var coordinator: СarriageSchemeViewControllerCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
