//
//  RouteResultViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/17/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

protocol RouteResultViewControllerInteractor: class {
    func prepareForShowResult(completion: @escaping (_ route: [Route]?,_ error: String?) -> ())
}

protocol RouteResultViewControllerCoordinator: class {
    
}

class RouteResultViewController: UIViewController {
    
    var interactor: RouteResultViewControllerInteractor!
    var coordinator: RouteResultViewControllerCoordinator?

    @IBOutlet weak var resultTableView: UITableView!
    
    private var searchResult = [Route]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareResultForTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

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
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.searchResultCell, for: indexPath)!
        cell.configure(with: searchResult[indexPath.row])
        cell.tapped = { model in
            print(model)
        }
        return cell
    }
}
