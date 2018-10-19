//
//  AutocompleteCell.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class AutocompleteCell: UITableViewCell {

    @IBOutlet weak var autocompleteLabel: UILabel!
    
    private var tapRecognizer: UITapGestureRecognizer?
    var tapped: ((AutocompleteAPIElement) -> Void)?
    var model: AutocompleteAPIElement!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        autocompleteLabel.text = nil
    }
    
    func configure(with element: AutocompleteAPIElement) {
        
        autocompleteLabel.text = element.label
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedInCell))
        tapRecognizer?.numberOfTapsRequired = 1
        tapRecognizer?.numberOfTouchesRequired = 1
        tapRecognizer?.delegate = self
        if let aRecognizer = tapRecognizer {
            addGestureRecognizer(aRecognizer)
        }
        model = element
    }
    
    @objc private func tappedInCell(recognizer: UITapGestureRecognizer?) {
        tapped?(model)
    }
}
