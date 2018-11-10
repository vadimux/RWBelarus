//
//  СarriageSchemeViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/3/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

protocol СarriageSchemeViewControllerInteractor: class {

    func fetchСarriageScheme(completion: @escaping (_ information: SchemeCarAPIModel?, _ error: String?) -> Void)
}

protocol СarriageSchemeViewControllerCoordinator: class {
    
}

class CarriageSchemeViewController: UIViewController {
    
    @IBOutlet weak var carriageTableView: UITableView!
    
    @IBOutlet weak var routeInfoView: UIView!
    @IBOutlet weak var trainTypeImage: UIImageView!
    @IBOutlet weak var trainNumberLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var trainTypeLabel: UILabel!
    
    var interactor: СarriageSchemeViewControllerInteractor!
    var coordinator: СarriageSchemeViewControllerCoordinator?
    
    private var information: SchemeCarAPIModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carriageTableView.hideEmptyCells()
        routeInfoView.isHidden = true
        interactor.fetchСarriageScheme { information, error in
            if error != nil {
                self.carriageTableView.hideToastActivity()
                self.view.makeToast(error, duration: 3.0, position: .center)
                return
            }
            if let information = information {
                self.information = information
                self.prepareForShow()
                self.carriageTableView.reloadData()
            }
        }
    }
    
    func prepareForShow() {
        routeInfoView.isHidden = false
        self.trainNumberLabel.text = information?.trainNumber
        guard let from = information?.from, let to = information?.to else { return }
        self.routeLabel.text = "\(from) - \(to)"

        (self.trainTypeLabel.text, self.trainTypeImage.image) = {
            switch TrainImageType(rawValue: self.information?.trainType ?? "") {
            case .internationalLines?:
                return (TrainType.internationalLines.rawValue, R.image.international())
            case .regionalEconomyLines?:
                return (TrainType.regionalEconomyLines.rawValue, R.image.region())
            case .regionalBusinessLines?:
                return (TrainType.regionalBusinessLines.rawValue, R.image.regionBusiness())
            case .interregionalEconomyLines?:
                return (TrainType.interregionalEconomyLines.rawValue, R.image.interregionalEconomy())
            case .interregionalBusinessLines?:
                return (TrainType.interregionalBusinessLines.rawValue, R.image.interregionalBusiness())
            case .cityLines?:
                return (TrainType.cityLines.rawValue, R.image.city())
            default:
                return (nil, nil)
            }
        }()
    }

}

extension CarriageSchemeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return information?.tariffs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return information?.tariffs[section].cars.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = CarriageHeader.instanceFromNib() as? CarriageHeader else {
            return nil
        }
        headerView.typeLabel.text = "Тип: ".localized + (information?.tariffs[section].type ?? "")
        headerView.tariffLabel.text = "Тариф: ".localized + (information?.tariffs[section].priceByn ?? "")
        headerView.carrierLabel.text = "Перевозчик: ".localized + (information?.tariffs[section].cars.first?.carrier ?? "")
        headerView.ownerLabel.text = "Принадлежность вагона: ".localized + (information?.tariffs[section].cars.first?.owner ?? "")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.carriageSchemeCell, for: indexPath)!
        guard let car = information?.tariffs[indexPath.section].cars[indexPath.row] else { return UITableViewCell() }
        cell.configure(with: car)
        return cell
    }
}
