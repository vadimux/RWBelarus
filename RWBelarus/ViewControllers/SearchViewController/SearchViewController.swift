//
//  SearchViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/15/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit
import Toast_Swift

protocol SearchViewControllerInteractor: class {
    var fromData: AutocompleteAPIElement? { get set }
    var toData: AutocompleteAPIElement? { get set }
    func callAutocomplete(for station: String, completion: @escaping (_ route: AutocompleteAPI?, _ error: String?) -> ())
}

protocol SearchViewControllerCoordinator: class {
    func showResult(vc: UIViewController, from: AutocompleteAPIElement?, to: AutocompleteAPIElement?)
}

class SearchViewController: UIViewController {
    
    var interactor: SearchViewControllerInteractor!
    var coordinator: SearchViewControllerCoordinator?
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stackViewVC: UIStackView!
    @IBOutlet weak var autocompleteTableView: UITableView!
    
    private var textTimer: Timer?
    private var autocompleteResult: AutocompleteAPI?
    private var activeTextFieldTag: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromTextField.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        toTextField.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        configureUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    private func configureUI() {
        autocompleteTableView.isHidden = true
        autocompleteTableView.tableFooterView = UIView()
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
                self.stackViewVC.removeArrangedSubview(self.autocompleteTableView)
                self.stackViewVC.setNeedsLayout()
                self.stackViewVC.layoutIfNeeded()
                self.stackViewVC.insertArrangedSubview(self.autocompleteTableView, at: self.activeTextFieldTag + 1)
                self.stackViewVC.setNeedsLayout()
            }
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        coordinator?.showResult(vc: self, from: self.interactor.fromData, to: self.interactor.toData)
    }
    
    private func hideTableView() {
        DispatchQueue.main.async {
            self.view.hideToastActivity()
            self.autocompleteTableView.isHidden = true
        }
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.autocompleteCell, for: indexPath)!
        guard let result = autocompleteResult else {
            return UITableViewCell()
        }
        cell.configure(with: result[indexPath.row])
        cell.tapped = { model in
            if self.activeTextFieldTag == 0 {
                self.fromTextField.text = model.value
                self.interactor.fromData = model
            } else {
                self.toTextField.text = model.value
                self.interactor.toData = model
            }
            self.hideTableView()
        }
        return cell
    }
    

}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextFieldTag = textField.tag
        self.hideTableView()
    }
}
