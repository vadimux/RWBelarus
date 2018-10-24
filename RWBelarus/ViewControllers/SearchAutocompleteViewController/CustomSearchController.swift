//
//  CustomSearchController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/24/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class CustomSearchController: UISearchController {
    
    var _searchBar: CustomSearchBar
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self._searchBar = CustomSearchBar()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.dimsBackgroundDuringPresentation = false
        self.hidesNavigationBarDuringPresentation = false
        self._searchBar.searchBarStyle = .minimal
        self._searchBar.placeholder = "Поиск станции или города".localized
        self._searchBar.barTintColor = .clear
        self._searchBar.tintColor = .white
        self._searchBar.autocapitalizationType = .allCharacters
        self._searchBar.setTextColor(color: .white)
        self._searchBar.setPlaceholderTextColor(color: .white)
    }
    
    override init(searchResultsController: UIViewController?) {
        self._searchBar = CustomSearchBar()
        super.init(searchResultsController: searchResultsController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var searchBar: UISearchBar {
        return self._searchBar
    }
}


class CustomSearchBar: UISearchBar {
    
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
    }
}
