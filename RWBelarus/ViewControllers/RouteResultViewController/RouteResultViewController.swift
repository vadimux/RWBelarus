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
    func showFullRoute(for route: Route)
    func dismiss()
}

class RouteResultViewController: UIViewController {
    
    var interactor: RouteResultViewControllerInteractor!
    weak var coordinator: RouteResultViewControllerCoordinator?

    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    private var searchResult = [Route]()
    private var imageHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = interactor?.prepareForTitle()
        prepareResultForTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            self.coordinator?.dismiss()
        }
    }

    private func prepareResultForTableView() {
        
        resultTableView.makeToastActivity(.center)
        resultTableView.hideEmptyCells()

        resultTableView.backgroundView = emptyView
        resultTableView.backgroundView?.isHidden = true
        
        interactor.prepareForShowResult { [weak self] result, error in
            guard let `self` = self else { return }
            if error != nil {
                self.resultTableView.hideToastActivity()
                self.view.makeToast(error, duration: 3.0, position: .center)
                self.resultTableView.backgroundView?.isHidden = false
                if let imageHeight = self.imageHeight {
                   self.topConstraint.constant = imageHeight + 44
                }
                return
            }
            self.searchResult = result ?? []
            guard let count = result?.count, count > 0 else {
                self.resultTableView.hideToastActivity()
                self.resultTableView.backgroundView?.isHidden = false
                if let imageHeight = self.imageHeight {
                    self.topConstraint.constant = imageHeight + 44
                }
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
            cell.configure(with: interactor.prepareForHeaderView())
            imageHeight = cell.bounds.height
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.searchResultCell, for: indexPath)!
        cell.configure(with: searchResult[indexPath.row - 1])
        cell.tapped = { [weak self] route in
            guard let `self` = self else { return }
            self.coordinator?.showFullRoute(for: route)
        }
        return cell
    }
}
