//
//  SettingsViewInteractor.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/19/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class SettingsViewInteractor: SettingsViewControllerInteractor {
    
//    private var arrayText = ["Отправить письмо разработчикам".localized, "Поделиться с друзьями".localized]
    private var arrayText = ["Отправить письмо разработчикам".localized]
    
    func countSettings() -> Int {
        return arrayText.count
    }
    
    func showInfoCells(indexPath: IndexPath) -> String {
        return arrayText[indexPath.row]
    }
}
