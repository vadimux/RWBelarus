//
//  AutocompleteDataSource.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/15/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit

protocol AutocompleteDelegate: class {
    func onAutocompleteTapped(model: AutocompleteAPIElement)
    func onRouteTapped(fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement)
}

class AutocompleteDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private weak var tableView: UITableView?
    private var emptyView: UIView?
    private var autocompleteResult: AutocompleteAPI?
    private var searchElement: String?
    private weak var delegate: AutocompleteDelegate?
    private var isAutocompleteRouteShown: Bool = false
    private var routeData = [RouteCoreData]()
    
    required init(with tableView: UITableView, delegate: AutocompleteDelegate, emptyView: UIView) {
        super.init()

        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.emptyView = emptyView
        self.delegate = delegate
    }
    
    func reload(autocompleteResult: AutocompleteAPI?, _ searchElement: String? = nil) {
        isAutocompleteRouteShown = false
        self.autocompleteResult = autocompleteResult
        self.searchElement = searchElement
        self.tableView?.reloadData()
    }
    
    func reload() {
        self.routeData = CoreDataManager.shared().loadRoute()
        isAutocompleteRouteShown = true
        self.tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isAutocompleteRouteShown ? self.routeData.count : autocompleteResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isAutocompleteRouteShown {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.autocompleteRouteCell, for: indexPath)!
            cell.configure(with: routeData[indexPath.row])
            cell.tapped = { fromData, toData in
                self.delegate?.onRouteTapped(fromData: fromData, toData: toData)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.autocompleteCell, for: indexPath)!
        guard let result = autocompleteResult else {
            return UITableViewCell()
        }
        cell.configure(with: result[indexPath.row], searchElement: self.searchElement)
        cell.tapped = { model in
            self.delegate?.onAutocompleteTapped(model: model)
        }
        return cell
    }
    
}
