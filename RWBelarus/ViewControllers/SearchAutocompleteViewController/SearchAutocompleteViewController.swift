//
//  SearchAutocompleteViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/23/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit
import Toast_Swift
import Cache

protocol SearchAutocompleteViewControllerInteractor: class {
    func callAutocomplete(for station: String, completion: @escaping (_ route: AutocompleteAPI?, _ error: String?) -> ())
}

protocol SearchAutocompleteViewControllerCoordinator: class {
    func dismiss(vc: UIViewController)
    func dismiss(vc: UIViewController, withData: AutocompleteAPIElement)
}


class SearchAutocompleteViewController: UIViewController {
    
    @IBOutlet weak var autocompleteTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var interactor: SearchAutocompleteViewControllerInteractor!
    var coordinator: SearchAutocompleteViewControllerCoordinator?
    
    private var textTimer: Timer?
    private var autocompleteResult: AutocompleteAPI?
    private var searchElement: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        searchBar.becomeFirstResponder()
    }
    
    private func configureUI() {
        autocompleteTableView.isHidden = true
        autocompleteTableView.tableFooterView = UIView()
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.definesPresentationContext = true
        
        if let searchTextField = self.searchBar.value(forKey: "_searchField") as? UITextField, let clearButton = searchTextField.value(forKey: "_clearButton") as? UIButton, let placeholder = searchTextField.value(forKey: "placeholderLabel") as? UILabel {
            let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = .white
            placeholder.textColor = .white
        }
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
//            let cache = Cache.sharedInstance
//            try? cache.saveToCache(autocompleteElement: model)
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
