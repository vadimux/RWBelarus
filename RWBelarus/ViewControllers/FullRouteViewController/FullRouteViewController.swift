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
    func fetchFullRoute(completion: @escaping (_ stations: [RouteItem]?, _ error: String?) -> Void)
}

protocol FullRouteViewControllerCoordinator: class {
    
}

class FullRouteViewController: UIViewController {
    
    var interactor: FullRouteViewControllerInteractor!
    var coordinator: FullRouteViewControllerCoordinator?

    private var fullRouteStations = [RouteItem]()
    @IBOutlet weak var fullRouteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fullRouteTableView.makeToastActivity(.center)
        interactor.fetchFullRoute { result, error in
            if let _ = error {
                self.fullRouteTableView.hideToastActivity()
                return
            }
            self.fullRouteStations = result ?? []
            self.fullRouteTableView.reloadData()
            self.fullRouteTableView.hideToastActivity()
        }
    }
    
}


extension FullRouteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullRouteStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fullRouteCell, for: indexPath)!
        cell.configure(with: fullRouteStations[indexPath.row])
//        cell.tapped = { model in
//            self.coordinator?.showFullRoute(vc: self, for: model)
//        }
        return cell
    }
}
