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
    private let searchController = UISearchController(searchResultsController: nil)
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
        
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.showsCancelButton = true
        self.searchController.searchBar.placeholder = "Поиск станции или города".localized
        self.searchController.searchBar.barTintColor = .clear
        self.searchController.searchBar.tintColor = .white
        self.searchController.searchBar.autocapitalizationType = .allCharacters
        self.searchController.searchBar.setTextColor(color: .white)
        self.searchController.searchBar.setTextFieldClearButtonColor(color: .white)
        self.searchController.searchBar.setPlaceholderTextColor(color: .white)
        self.navigationItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true
    }
    
    @objc private func callAutocomplete(_ timer: Timer) {
        
        self.view.makeToastActivity(.center)
        
        guard let station = timer.userInfo as? String, station.count > 0 else {
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

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.coordinator?.dismiss(vc: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if textTimer != nil {
            textTimer?.invalidate()
            textTimer = nil
        }
        textTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callAutocomplete(_:)), userInfo: searchText, repeats: false)
    }
}
