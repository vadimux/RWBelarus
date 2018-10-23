//
//  SearchResultCell.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/17/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var trainNumberLabel: UILabel!
    @IBOutlet weak var trainRouteLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var finishTime: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var typeTrainImage: UIImageView!
    @IBOutlet weak var exceptStationLabel: UILabel!
    @IBOutlet weak var ticketTableView: UITableView!
    @IBOutlet weak var ticketTableConstraint: NSLayoutConstraint!
    
    var tapped: ((Route) -> Void)?
    var model: Route!
    
    private var tapRecognizer: UITapGestureRecognizer?
    private var ticketInfo = [TrainPlace]()
    private let kObservedPropertyName = "contentSize"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ticketTableView.addObserver(self, forKeyPath: kObservedPropertyName, options: .new, context: nil)
        ticketTableView.hideEmptyCells()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedInCell))
        tapRecognizer?.numberOfTapsRequired = 1
        tapRecognizer?.numberOfTouchesRequired = 1
        tapRecognizer?.delegate = self
        if let aRecognizer = tapRecognizer {
            addGestureRecognizer(aRecognizer)
        }
    }
    
    deinit {
        ticketTableView.removeObserver(self, forKeyPath: kObservedPropertyName)
    }

        
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trainNumberLabel.text = nil
        trainRouteLabel.text = nil
        startTimeLabel.text = nil
        durationLabel.text = nil
        finishTime.text = nil
        daysLabel.text = nil
        typeTrainImage.image = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kObservedPropertyName {
            if let newvalue = change?[.newKey] {
                guard let newsize  = newvalue as? CGSize else { return }
                self.ticketTableConstraint.constant = newsize.height
            }
        }
    }
    
    func configure(with element: Route) {
        
        trainNumberLabel.text = element.trainId
        trainRouteLabel.text = element.routeName
        startTimeLabel.text = element.startTime
        durationLabel.text = element.travelTime
        finishTime.text = element.finishTime
        daysLabel.text = element.days
        exceptStationLabel.text = element.exceptStops
        
        typeTrainImage.image = {
            switch element.trainType {
            case .internationalLines:
                return R.image.international()
            case .regionalEconomyLines:
                return R.image.region()
            case .regionalBusinessLines:
                return R.image.regionBusiness()
            case .interregionalEconomyLines:
                return R.image.interregionalEconomy()
            case .interregionalBusinessLines:
                return R.image.interregionalBusiness()
            case .cityLines:
                return R.image.city()
            default:
                return nil
            }
        }()
        
        if element.place.count > 0 {
            self.ticketInfo = element.place
            self.ticketTableView.reloadData()
        }
        model = element
    }
    
    @objc private func tappedInCell(recognizer: UITapGestureRecognizer?) {
        tapped?(model)
    }
}


extension SearchResultCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ticketInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ticketInfoCell, for: indexPath)!
        cell.configure(with: self.ticketInfo[indexPath.row])
        return cell
    }
}
