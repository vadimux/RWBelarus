//
//  RouteResultViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/17/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

protocol RouteResultViewControllerInteractor: class {
    func prepareForTitle() -> String
    func prepareForShowResult(completion: @escaping (_ route: [Route]?,_ error: String?) -> ())
}

protocol RouteResultViewControllerCoordinator: class {
    func showFullRoute(vc: UIViewController, for route: Route)
}

class RouteResultViewController: UIViewController {
    
    var interactor: RouteResultViewControllerInteractor!
    var coordinator: RouteResultViewControllerCoordinator?

    @IBOutlet weak var resultTableView: UITableView!
    
    private var searchResult = [Route]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = interactor?.prepareForTitle()
        prepareResultForTableView()
    }
    
    private func prepareResultForTableView() {
        
        self.resultTableView.makeToastActivity(.center)
        self.resultTableView.hideEmptyCells()
        
        interactor.prepareForShowResult() { result, error in
            self.searchResult = result ?? []
            guard let count = result?.count, count > 0 else {
                return
            }
            DispatchQueue.main.async {
                self.resultTableView.hideToastActivity()
                self.resultTableView.reloadData()
            }
            
        }
    }

}

extension RouteResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.requestCell, for: indexPath)!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.searchResultCell, for: indexPath)!
        cell.configure(with: searchResult[indexPath.row - 1])
        cell.tapped = { model in
            self.coordinator?.showFullRoute(vc: self, for: model)
        }
        return cell
    }
}
