//
//  Locale+currentLanguageCode.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/19/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

extension Locale {
    
    var currentLanguageCode: String {
        return Locale.current.languageCode != "ru" && Locale.current.languageCode != "by" ? "en" : Locale.current.languageCode ?? "ru"
    }
    
}
