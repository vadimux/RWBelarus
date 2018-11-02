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
    @IBOutlet weak var additionalInfoLabel: UILabel!
    
    private var tapRecognizer: UITapGestureRecognizer?
    var tapped: ((AutocompleteAPIElement) -> Void)?
    var model: AutocompleteAPIElement!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        autocompleteLabel.text = nil
        additionalInfoLabel.text = nil
    }
    
    func configure(with element: AutocompleteAPIElement, searchElement: String?) {
        
        if let value = element.value?.uppercased(), let additionalInfo = element.label, let searchElement = searchElement {
            let string: NSMutableAttributedString = NSMutableAttributedString(string: (value))
            string.setColor(color: .red, forText: searchElement)
            autocompleteLabel.attributedText = string
            additionalInfoLabel.text = additionalInfo
        }
        
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

extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}
