//
//  SearchAutocompleteViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/23/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit
import Toast_Swift

protocol SearchAutocompleteViewControllerInteractor: class {
    func callAutocomplete(for station: String, completion: @escaping (_ route: AutocompleteAPI?, _ error: String?) -> ())
}

protocol SearchAutocompleteViewControllerCoordinator: class {
    func dismiss(vc: UIViewController)
    func dismiss(vc: UIViewController, withData: AutocompleteAPIElement)
}


class SearchAutocompleteViewController: UIViewController {
    
    @IBOutlet weak var autocompleteTableView: UITableView!

    var interactor: SearchAutocompleteViewControllerInteractor!
    var coordinator: SearchAutocompleteViewControllerCoordinator?
    
    private var textTimer: Timer?
    private var autocompleteResult: AutocompleteAPI?
    private let searchController = CustomSearchController()
    private var searchElement: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(0.1) {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    private func delay(_ delay: Double, completion: @escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: completion)
    }
    
    private func configureUI() {
        autocompleteTableView.isHidden = true
        autocompleteTableView.tableFooterView = UIView()
        self.navigationItem.setHidesBackButton(true, animated:true)
        configureSearchBar()
    }
    
    private func configureSearchBar() {
        
        self.searchController.searchBar.delegate = self
        self.navigationItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true
    }
    
    @objc private func callAutocomplete(_ timer: Timer) {
        
        self.view.makeToastActivity(.center)
        
        guard let station = timer.userInfo as? String, station.count > 0 else {
            self.autocompleteResult = nil
            self.autocompleteTableView.reloadData()
            self.view.hideToastActivity()
            return
        }
        
        interactor.callAutocomplete(for: station) { result, error in
            self.autocompleteResult = result
            if let error = error {
                self.view.makeToast(error)
                self.view.hideToastActivity()
                return
            }
            guard let count = result?.count, count > 0 else {
                self.autocompleteResult = nil
                self.autocompleteTableView.reloadData()
                self.view.hideToastActivity()
                return
            }

            self.autocompleteTableView.isHidden = false
            self.searchElement = station
            self.autocompleteTableView.reloadData()
            self.view.hideToastActivity()
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.coordinator?.dismiss(vc: self)
    }
    
}

extension SearchAutocompleteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.autocompleteCell, for: indexPath)!
        guard let result = autocompleteResult else {
            return UITableViewCell()
        }
        cell.configure(with: result[indexPath.row], searchElement: self.searchElement)
        cell.tapped = { model in
            self.coordinator?.dismiss(vc: self, withData: model)
        }
        return cell
    }
}

extension SearchAutocompleteViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if textTimer != nil {
            textTimer?.invalidate()
            textTimer = nil
        }
        textTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callAutocomplete(_:)), userInfo: searchText, repeats: false)
    }
}
