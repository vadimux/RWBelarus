//
//  CarriageSchemeCell.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/4/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class CarriageSchemeCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var tariffLabel: UILabel!
    @IBOutlet weak var carrierLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var infoTableViewConstraint: NSLayoutConstraint!
    
    private var placeInfo = [Car]()
    private let kObservedPropertyName = "contentSize"
    
    deinit {
        infoTableView.removeObserver(self, forKeyPath: kObservedPropertyName)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        typeLabel.text = nil
        tariffLabel.text = nil
        carrierLabel.text = nil
        ownerLabel.text = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kObservedPropertyName {
            if let newvalue = change?[.newKey] {
                guard let newsize  = newvalue as? CGSize else { return }
                self.infoTableViewConstraint.constant = newsize.height
            }
        }
    }
    
    func configure(with info: Tariff?) {
        typeLabel.text = "Тип: ".localized + (info?.type ?? "")
        tariffLabel.text = "Тариф: ".localized + (info?.priceByn ?? "")
        placeInfo = info?.cars ?? []
    }
}

extension CarriageSchemeCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.carriageFullInfoCell, for: indexPath)!
        cell.configure(with: self.placeInfo[indexPath.row])
        return cell
    }
}
