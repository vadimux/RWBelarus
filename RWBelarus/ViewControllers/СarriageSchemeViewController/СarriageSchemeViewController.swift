//
//  СarriageSchemeViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/3/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

protocol СarriageSchemeViewControllerInteractor: class {

    func fetchСarriageScheme(completion: @escaping (_ information: TrainPlacesAPI?, _ error: String?) -> Void)
}

protocol СarriageSchemeViewControllerCoordinator: class {
    
}

class CarriageSchemeViewController: UIViewController {
    
    @IBOutlet weak var carriageTableView: UITableView!
    
//    @IBOutlet weak var trainTypeImage: UIImageView!
//    @IBOutlet weak var trainNumberLabel: UILabel!
//    @IBOutlet weak var routeLabel: UILabel!
//    @IBOutlet weak var trainTypeLabel: UILabel!
    
    var interactor: СarriageSchemeViewControllerInteractor!
    var coordinator: СarriageSchemeViewControllerCoordinator?
    
    private var information: TrainPlacesAPI?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.fetchСarriageScheme { information, error in
            //TODO: add error for information = nil
            if let information = information {
                self.information = information
                self.carriageTableView.reloadData()
//                self.prepareForShow()
                print("***")
                print(information.tariffs.count)
                for element in information.tariffs {
                    print(element.priceByn)
                    print(element.typeAbbr)
                    print(element.description)
                    print(element.type)
                    print("&&")
                    print(element.cars.count)
                    for car in element.cars {
                        print(car.number)
                        print(car.carrier)
                        print(car.owner)
                        print(car.emptyPlaces)
                        print(car.imgSrc)
                    }
                }
            }
        }
    }
    
//    func prepareForShow() {
//        self.trainNumberLabel.text = information?.trainNumber
//        self.routeLabel.text = "\(information?.route.from) - \(information?.route.to)"
//        self.trainTypeLabel.text = self.information?.trainType
//        self.trainTypeImage.image = {
//            switch TrainType(rawValue: self.information?.trainType ?? "") {
//            case .internationalLines?:
//                return R.image.international()
//            case .regionalEconomyLines?:
//                return R.image.region()
//            case .regionalBusinessLines?:
//                return R.image.regionBusiness()
//            case .interregionalEconomyLines?:
//                return R.image.interregionalEconomy()
//            case .interregionalBusinessLines?:
//                return R.image.interregionalBusiness()
//            case .cityLines?:
//                return R.image.city()
//            default:
//                return nil
//            }
//        }()
//    }

}

extension CarriageSchemeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return information?.tariffs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.carriageSchemeCell, for: indexPath)!
        cell.configure(with: information?.tariffs[indexPath.row])
        return cell
    }
}
