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
    func callAutocomplete(for station: String, completion: @escaping (_ route: AutocompleteAPI?, _ error: String?) -> Void)
}

protocol SearchAutocompleteViewControllerCoordinator: class {
    func dismiss(vc: UIViewController)
    func dismiss(vc: UIViewController, withData: AutocompleteAPIElement)
    func dismiss(vc: UIViewController, fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement)
}

class SearchAutocompleteViewController: UIViewController {
    
    @IBOutlet weak var autocompleteTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTypeSegmentControl: UISegmentedControl!
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var searchStackView: UIStackView!
    
    var interactor: SearchAutocompleteViewControllerInteractor!
    var coordinator: SearchAutocompleteViewControllerCoordinator?
    
    private var textTimer: Timer?
    private var dataSource: AutocompleteDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        searchBar.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.dataSource = AutocompleteDataSource(with: autocompleteTableView, delegate: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureUI() {
        
        autocompleteTableView.isHidden = true
        autocompleteTableView.tableFooterView = UIView()
        autocompleteTableView.backgroundView = emptyView
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.definesPresentationContext = true
        
        if let searchTextField = self.searchBar.value(forKey: "_searchField") as? UITextField, let clearButton = searchTextField.value(forKey: "_clearButton") as? UIButton, let placeholder = searchTextField.value(forKey: "placeholderLabel") as? UILabel {
            let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = .white
            placeholder.textColor = .white
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            autocompleteTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            autocompleteTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc private func callAutocomplete(_ timer: Timer) {
        
        self.view.makeToastActivity(.center)
        autocompleteTableView.backgroundView?.isHidden = true
        autocompleteTableView.isHidden = false
        
        guard let station = timer.userInfo as? String, station.count > 0 else {
            self.dataSource?.reload(autocompleteResult: nil)
            self.autocompleteTableView.backgroundView?.isHidden = false
            self.view.hideToastActivity()
            return
        }
        
        interactor.callAutocomplete(for: station) { [weak self] result, error in
            if error != nil {
                self?.dataSource?.reload(autocompleteResult: nil)
                self?.autocompleteTableView.hideToastActivity()
                self?.view.makeToast(error, duration: 3.0, position: .center)
                self?.autocompleteTableView.backgroundView?.isHidden = false
                return
            }
            guard let count = result?.count, count > 0 else {
                self?.dataSource?.reload(autocompleteResult: nil)
                self?.autocompleteTableView.backgroundView?.isHidden = false
                self?.view.hideToastActivity()
                return
            }
            self?.dataSource?.reload(autocompleteResult: result, station)
            self?.view.hideToastActivity()
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.coordinator?.dismiss(vc: self)
    }
    
    @IBAction func sectionTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            if CoreDataManager.shared().loadRoute().isEmpty {
               self.view.makeToast("Не доступно до первого поиска по маршруту".localized, duration: 3.0, position: .center)
            } else {
                autocompleteTableView.backgroundView?.isHidden = true
                autocompleteTableView.isHidden = false
                searchStackView.isHidden = true
                self.dataSource?.reload()
            }
            return
        }
        autocompleteTableView.backgroundView?.isHidden = true
        autocompleteTableView.isHidden = false
        searchStackView.isHidden = false
        self.dataSource?.reload(autocompleteResult: nil, nil)
    }
}

extension SearchAutocompleteViewController: AutocompleteDelegate {
    
    func onAutocompleteTapped(model: AutocompleteAPIElement) {
        self.coordinator?.dismiss(vc: self, withData: model)
    }
    
    func onRouteTapped(fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement) {
        self.coordinator?.dismiss(vc: self, fromData: fromData, toData: toData)
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
