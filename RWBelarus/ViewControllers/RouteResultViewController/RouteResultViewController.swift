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
    func prepareForShowResult(completion: @escaping (_ route: [Route]?, _ error: String?) -> Void)
    func prepareForHeaderView() -> (String, String, String)
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
        
        NetworkManager.getScheduleByStation(station: "Лида", date: "tomorrow") { result in
            switch result {
            case .success(let routes):
                print(routes?.count)
                for route in routes! {
                    print(route.trainType)
                    print(route.trainId)
                    print(route.routeName)
                    print(route.finishTime)
                    print(route.startTime)
                    print(route.days)
                    print(route.exceptStops)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func prepareResultForTableView() {
        
        self.resultTableView.makeToastActivity(.center)
        self.resultTableView.hideEmptyCells()
        
        interactor.prepareForShowResult() { result, error in
            if let error = error {
                self.resultTableView.hideToastActivity()
                return
            }
            self.searchResult = result ?? []
            guard let count = result?.count, count > 0 else {
                self.resultTableView.hideToastActivity()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.headerResultCell, for: indexPath)!
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            cell.configure(with: interactor.prepareForHeaderView())
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.searchResultCell, for: indexPath)!
        cell.configure(with: searchResult[indexPath.row - 1], rootViewController: self.navigationController)
        cell.tapped = { model in
            self.coordinator?.showFullRoute(vc: self, for: model)
        }
        return cell
    }
}
