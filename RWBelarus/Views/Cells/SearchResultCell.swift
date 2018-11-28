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
    @IBOutlet weak var ticketStackView: UIStackView!
    
    var tapped: ((Route) -> Void)?
    var model: Route!
    
    private var tapRecognizer: UITapGestureRecognizer?
    private var ticketInfo = [TrainPlace]()
    private weak var observer: NSKeyValueObservation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observer = ticketTableView.observe(\.contentSize, options: [.new]) { (_, change) in
            if let newValue = change.newValue {
                self.ticketTableConstraint.constant = newValue.height
            }
        }
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
        observer?.invalidate()
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
        exceptStationLabel.text = nil
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
            UIImage.configureImage(for: element.trainType)
        }()
        
        ticketStackView.isHidden = !(element.place.count > 0)
        
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
        cell.tapped = { [weak self] link in
            guard let `self` = self, let rootVC = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController), let link = link, self.model.trainType != .regionalEconomyLines, self.model.trainType != .cityLines else { return }
            let coordinator = СarriageSchemeViewCoordinator.init(rootViewController: rootVC, urlPath: link)
            coordinator.start(withCallback: nil)
        }
        return cell
    }
}
