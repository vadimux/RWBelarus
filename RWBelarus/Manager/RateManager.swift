//
//  RateManager.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/19/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit
import StoreKit

@available(iOS 10.3, *)
class RateManager {
    
    private static let kRunCount = "run_count"
    
    class func incrementCount() {
        
        // get current number of times app has been launched
        let count = UserDefaults.standard.integer(forKey: kRunCount)
        
        if count < 15 {
            // increment received number by one
            UserDefaults.standard.set(count + 1, forKey: kRunCount)
            // save changes to disk
            UserDefaults.standard.synchronize()
        }
    }
    
    class func showRatesController() {
        // get current number of times app has been launched
        let count = UserDefaults.standard.integer(forKey: kRunCount)
        
        if count == 15 {
            // show view with rate
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                SKStoreReviewController.requestReview()
            })
            // reset the number of times app has been launched
            UserDefaults.standard.set(0, forKey: kRunCount)
            // save changes to disk
            UserDefaults.standard.synchronize()
        }
    }
}
