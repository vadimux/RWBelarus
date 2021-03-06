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
    func dismiss()
    func dismiss(withData: AutocompleteAPIElement)
    func dismiss(fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement)
}

class SearchAutocompleteViewController: UIViewController {
    
    @IBOutlet weak var autocompleteTableView: UITableView!
    @IBOutlet weak var searchTypeSegmentControl: UISegmentedControl!
    @IBOutlet var emptyView: UIView!
    
    var interactor: SearchAutocompleteViewControllerInteractor!
    weak var coordinator: SearchAutocompleteViewControllerCoordinator?
    
    private var textTimer: Timer?
    private var dataSource: AutocompleteDataSource?
    private lazy var searchBar = UISearchBar(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSearchBar()
        configureCancelBarButton()
        
        self.dataSource = AutocompleteDataSource(with: autocompleteTableView, delegate: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        textTimer?.invalidate()
    }
    
    func registerNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureSearchBar() {
        
        registerNotificationObservers()
        
        searchBar.placeholder = "Поиск по станции или маршруту".localized
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.becomeFirstResponder()
    }
    
    func configureCancelBarButton() {
        let font: UIFont? = R.font.robotoRegular(size: 16)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let cancelButton = UIBarButtonItem()
        cancelButton.title = "Отмена".localized
        cancelButton.setTitleTextAttributes(attributes, for: .normal)
        cancelButton.action = #selector(cancelTapped)
        cancelButton.target = self
        self.navigationItem.setRightBarButton(cancelButton, animated: true)
    }
    
    private func configureUI() {
        
        autocompleteTableView.isHidden = true
        autocompleteTableView.tableFooterView = UIView()
        autocompleteTableView.backgroundView = emptyView
        searchTypeSegmentControl.isHidden = self.navigationController?.viewControllers.first is ScheduleStationViewController
        searchTypeSegmentControl?.setTitle("Города и станции".localized, forSegmentAt: 0)
        searchTypeSegmentControl?.setTitle("Маршруты".localized, forSegmentAt: 1)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        autocompleteTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        guard (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue != nil else { return }
        autocompleteTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    @objc func cancelTapped() {
        self.coordinator?.dismiss()
    }
    
    @IBAction func sectionTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            if CoreDataManager.shared().loadRoute().isEmpty {
               self.view.makeToast("Недоступно до первого поиска по маршруту".localized, duration: 3.0, position: .center)
            } else {
                autocompleteTableView.backgroundView?.isHidden = true
                autocompleteTableView.isHidden = false
                self.dataSource?.reload()
            }
            return
        }
        autocompleteTableView.backgroundView?.isHidden = true
        autocompleteTableView.isHidden = false
        self.dataSource?.reload(autocompleteResult: nil, nil)
    }
}

extension SearchAutocompleteViewController: AutocompleteDelegate {
    
    func onAutocompleteTapped(model: AutocompleteAPIElement) {
        self.coordinator?.dismiss(withData: model)
    }
    
    func onRouteTapped(fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement) {
        self.coordinator?.dismiss(fromData: fromData, toData: toData)
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
