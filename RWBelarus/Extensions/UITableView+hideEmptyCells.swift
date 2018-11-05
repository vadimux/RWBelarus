//
//  UITableView+hideEmptyCells.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/22/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

extension UITableView {
    func hideEmptyCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
}
