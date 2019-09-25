//
//  SearchViewInteractor.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit

class SearchViewInteractor: SearchViewControllerInteractor {
    
    var fromData: AutocompleteAPIElement?
    var toData: AutocompleteAPIElement?
    
    func configureSearchButtonState(with elements: [AutocompleteAPIElement?]) -> Int {
        return elements.reduce(0) { $1 == nil ? $0 + 1 : $0 }
    }
}
