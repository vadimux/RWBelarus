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
    func dismiss()
}

class CarriageSchemeViewController: UIViewController {
    
    @IBOutlet weak var carriageTableView: UITableView!
    @IBOutlet weak var routeInfoView: UIView!
    @IBOutlet weak var trainTypeImage: UIImageView!
    @IBOutlet weak var trainNumberLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var trainTypeLabel: UILabel!
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    var interactor: СarriageSchemeViewControllerInteractor!
    weak var coordinator: СarriageSchemeViewControllerCoordinator?
    
    private var information: SchemeCarAPIModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carriageTableView.hideEmptyCells()
        routeInfoView.isHidden = true
        
        carriageTableView.backgroundView = emptyView
        carriageTableView.backgroundView?.isHidden = true
        
        interactor.fetchСarriageScheme { [weak self] information, error in
            if error != nil {
                self?.carriageTableView.hideToastActivity()
                self?.view.makeToast(error, duration: 3.0, position: .center)
                self?.carriageTableView.backgroundView?.isHidden = false
                if let topViewHeight = self?.topViewHeightConstraint.constant {
                    self?.topConstraint.constant = topViewHeight + 44
                }
                return
            }
            if let information = information {
                self?.information = information
                self?.prepareForShow()
                self?.carriageTableView.reloadData()
            } else {
                self?.carriageTableView.backgroundView?.isHidden = false
                if let topViewHeight = self?.topViewHeightConstraint.constant {
                    self?.topConstraint.constant = topViewHeight + 44
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            self.coordinator?.dismiss()
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
                return (TrainType.internationalLines.localizedString(), R.image.international())
            case .regionalEconomyLines?:
                return (TrainType.regionalEconomyLines.localizedString(), R.image.region())
            case .regionalBusinessLines?:
                return (TrainType.regionalBusinessLines.localizedString(), R.image.regionBusiness())
            case .interregionalEconomyLines?:
                return (TrainType.interregionalEconomyLines.localizedString(), R.image.interregionalEconomy())
            case .interregionalBusinessLines?:
                return (TrainType.interregionalBusinessLines.localizedString(), R.image.interregionalBusiness())
            case .cityLines?:
                return (TrainType.cityLines.localizedString(), R.image.city())
            default:
                return (nil, nil)
            }
        }()
    }

}

extension CarriageSchemeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return information?.tariffs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return information?.tariffs?[section].cars?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = CarriageHeader.instanceFromNib() as? CarriageHeader else {
            return nil
        }
        headerView.typeLabel.text = "Тип: ".localized + (information?.tariffs?[section].type ?? "")
        headerView.tariffLabel.text = "Тариф: ".localized + (information?.tariffs?[section].priceByn ?? "")
        headerView.carrierLabel.text = "Перевозчик: ".localized + (information?.tariffs?[section].cars?.first?.carrier ?? "")
        headerView.ownerLabel.text = "Принадлежность вагона: ".localized + (information?.tariffs?[section].cars?.first?.owner ?? "")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.carriageSchemeCell, for: indexPath)!
        guard let car = information?.tariffs?[indexPath.section].cars?[indexPath.row] else { return UITableViewCell() }
        cell.configure(with: car)
        return cell
    }
}
