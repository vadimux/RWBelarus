//
//  SearchAutocompleteViewInteractor.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/23/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class SearchAutocompleteViewInteractor: SearchAutocompleteViewControllerInteractor {
    
    func callAutocomplete(for station: String, completion: @escaping (_ route: AutocompleteAPI?, _ error: String?) -> Void) {
        NetworkManager.autocomplete(term: station) { result in
            switch result {
            case .success(let autocomplete):
                completion(autocomplete, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}