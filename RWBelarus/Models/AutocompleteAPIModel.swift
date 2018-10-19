//
//  AutocompleteAPIModel.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

typealias AutocompleteAPI = [AutocompleteAPIElement]

class AutocompleteAPIElement: Codable {
    let autocompleteAPIPrefix, label, labelTail, value: String?
    let gid: String?
    let lon, lat: Double?
    let exp, ecp, otd: String?
    
    enum CodingKeys: String, CodingKey {
        case autocompleteAPIPrefix = "prefix"
        case label
        case labelTail = "label_tail"
        case value, gid, lon, lat, exp, ecp, otd
    }
    
    init(autocompleteAPIPrefix: String?, label: String?, labelTail: String?, value: String?, gid: String?, lon: Double?, lat: Double?, exp: String?, ecp: String?, otd: String?) {
        self.autocompleteAPIPrefix = autocompleteAPIPrefix
        self.label = label
        self.labelTail = labelTail
        self.value = value
        self.gid = gid
        self.lon = lon
        self.lat = lat
        self.exp = exp
        self.ecp = ecp
        self.otd = otd
    }
}
