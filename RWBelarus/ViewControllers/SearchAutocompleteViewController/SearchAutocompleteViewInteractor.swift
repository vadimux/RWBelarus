//
//  SearchAutocompleteViewInteractor.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/23/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import Cache

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

class Cache {
    
    private(set) var diskConfig: DiskConfig = DiskConfig(name: "Storage")
    private(set) var memoryConfig: MemoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
    static let sharedInstance = Cache()
    
    func checkCache(with key: String) throws -> Bool? {
        let cache = try self.getCache()
        // Check if Exists
        let hasElements = try cache?.existsObject(forKey: key)
        return hasElements
    }
    
    func retrieveFromCache(for key: String) throws -> Data? {
        let cache = try self.getCache()
        let result = try cache?.object(forKey: key)
        return result
    }
    
    func saveToCache(data: Data, key: String) throws {
        let cache = try self.getCache()
        try cache?.setObject(data, forKey: key)
    }
    
    func getCache() throws -> Storage<Data>? {
        let storage = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: Data.self))
        return storage
    }
}

//class Cache {
//
//    private(set) var diskConfig: DiskConfig = DiskConfig(name: "Storage")
//    private(set) var memoryConfig: MemoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
//    static let sharedInstance = Cache()
//
//    func checkCache() throws -> Bool? {
//        let cache = try self.getCache()
//        // Check if Exists
//        let hasAutocompleteAPIElements = try cache?.existsObject(forKey: String(describing: AutocompleteAPIElement.self))
//        return hasAutocompleteAPIElements
//    }
//
//    func retrieveFromCache() throws -> AutocompleteAPIElement? {
//        let cache = try self.getCache()
//        let result = try cache?.object(forKey: String(describing: AutocompleteAPIElement.self))
//        return result
//    }
//
//    func saveToCache(autocompleteElement: AutocompleteAPIElement) throws {
//        let cache = try self.getCache()
//        try cache?.setObject(autocompleteElement, forKey: String(describing: AutocompleteAPIElement.self))
//    }
//
//    func getCache() throws -> Storage<AutocompleteAPIElement>? {
//        let storage = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: AutocompleteAPIElement.self))
//
//        return storage
//    }
//}
