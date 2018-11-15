//
//  AutocompleteRouteCell.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/15/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class AutocompleteRouteCell: UITableViewCell {
    
    @IBOutlet weak var routeNameLabel: UILabel!
    
    private var tapRecognizer: UITapGestureRecognizer?
    var tapped: ((AutocompleteAPIElement, AutocompleteAPIElement) -> Void)?
    var model: RouteCoreData!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        routeNameLabel.text = nil
    }
    
    func configure(with route: RouteCoreData) {
        
        self.routeNameLabel.text = route.routeName
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedInCell))
        tapRecognizer?.numberOfTapsRequired = 1
        tapRecognizer?.numberOfTouchesRequired = 1
        tapRecognizer?.delegate = self
        if let aRecognizer = tapRecognizer {
            addGestureRecognizer(aRecognizer)
        }
        model = route
    }
    
    @objc private func tappedInCell(recognizer: UITapGestureRecognizer?) {
        let fromData = AutocompleteAPIElement(autocompleteAPIPrefix: nil, label: model.labelFrom, labelTail: nil, value: model.valueFrom, gid: nil, lon: nil, lat: nil, exp: model.fromExp, ecp: nil, otd: nil)
        let toData = AutocompleteAPIElement(autocompleteAPIPrefix: nil, label: model.labelTo, labelTail: nil, value: model.valueTo, gid: nil, lon: nil, lat: nil, exp: model.toExp, ecp: nil, otd: nil)
        tapped?(fromData, toData)
    }
}
