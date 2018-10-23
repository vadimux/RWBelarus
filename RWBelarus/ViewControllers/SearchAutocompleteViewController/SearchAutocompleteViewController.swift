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
//    var fromData: AutocompleteAPIElement? { get set }
//    var toData: AutocompleteAPIElement? { get set }
    func callAutocomplete(for station: String, completion: @escaping (_ route: AutocompleteAPI?, _ error: String?) -> ())
}

protocol SearchAutocompleteViewControllerCoordinator: class {
    func dismiss(vc: UIViewController)
//    func showResult(vc: UIViewController, from: AutocompleteAPIElement?, to: AutocompleteAPIElement?)
}


class SearchAutocompleteViewController: UIViewController {
    
    @IBOutlet weak var autocompleteTableView: UITableView!

    var interactor: SearchAutocompleteViewControllerInteractor!
    var coordinator: SearchAutocompleteViewControllerCoordinator?
    
    private var textTimer: Timer?
    private var autocompleteResult: AutocompleteAPI?
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        autocompleteTableView.isHidden = true
        autocompleteTableView.tableFooterView = UIView()
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.showsCancelButton = true
        self.navigationItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textTimer != nil {
            textTimer?.invalidate()
            textTimer = nil
        }
        
        guard let station = textField.text else {
            self.hideTableView()
            return
        }
        textTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callAutocomplete(_:)), userInfo: station, repeats: false)
    }
    
    @objc private func callAutocomplete(_ timer: Timer) {
        
        self.view.makeToastActivity(.center)
        
        guard let station = timer.userInfo as? String, station.count > 0 else {
            self.hideTableView()
            return
        }
        
        interactor.callAutocomplete(for: station) { result, error in
            self.autocompleteResult = result
            guard let count = result?.count, count > 0 else {
                self.hideTableView()
                return
            }
            DispatchQueue.main.async {
                self.autocompleteTableView.isHidden = false
                self.view.hideToastActivity()
                self.autocompleteTableView.reloadData()
            }
        }
    }
    
    private func hideTableView() {
        DispatchQueue.main.async {
            self.view.hideToastActivity()
            self.autocompleteTableView.isHidden = true
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
        cell.configure(with: result[indexPath.row])
//        cell.tapped = { model in
//            if self.activeTextFieldTag == 0 {
//                self.fromTextField.text = model.value
//                self.interactor.fromData = model
//            } else {
//                self.toTextField.text = model.value
//                self.interactor.toData = model
//            }
//            self.hideTableView()
//        }
        return cell
    }
}

extension SearchAutocompleteViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.coordinator?.dismiss(vc: self)
    }
}
