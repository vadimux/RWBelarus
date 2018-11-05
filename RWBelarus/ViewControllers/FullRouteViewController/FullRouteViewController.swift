//
//  FullRouteViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/29/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

protocol FullRouteViewControllerInteractor: class {
    var route: Route { get }
    func fetchFullRoute(completion: @escaping (_ stations: [RouteItem]?, _ error: String?) -> Void)
    func prepareForTitle() -> String 
}

protocol FullRouteViewControllerCoordinator: class {
    
}

class FullRouteViewController: UIViewController {
    
    @IBOutlet weak var fullRouteTableView: UITableView!
    @IBOutlet weak var trainTypeImage: UIImageView!
    @IBOutlet weak var trainNumberLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var trainTypeLabel: UILabel!
    
    var interactor: FullRouteViewControllerInteractor!
    var coordinator: FullRouteViewControllerCoordinator?
    
    private var fullRouteStations = [RouteItem]()
    private var selectedRouteStations = [RouteItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForShow()
        self.title = interactor?.prepareForTitle()
        self.fullRouteTableView.makeToastActivity(.center)
        interactor.fetchFullRoute { result, error in
            if let _ = error {
                self.fullRouteTableView.hideToastActivity()
                return
            }
            self.fullRouteStations = result ?? []
            self.createSelectedRoute()
            self.fullRouteTableView.reloadData()
            self.fullRouteTableView.hideToastActivity()
        }
    }
    
    func prepareForShow() {
        self.trainNumberLabel.text = self.interactor.route.trainId
        self.routeLabel.text = self.interactor.route.routeName
        self.trainTypeLabel.text = self.interactor.route.trainType.rawValue
        self.trainTypeImage.image = {
            switch self.interactor.route.trainType {
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
    }
    
    private func createSelectedRoute() {
        guard let fromStation = interactor.route.fromStation, let toStation = interactor.route.toStation else { return }
        
        if let startIndex = fullRouteStations.index(where: { ($0.station?.contains(find: fromStation))! }),
            let finishIndex = fullRouteStations.index(where: { ($0.station?.contains(find: toStation))! }) {
            
            let startDistance = fullRouteStations.distance(from: fullRouteStations.startIndex, to: startIndex)
            let finishDistance = fullRouteStations.distance(from: fullRouteStations.startIndex, to: finishIndex)
            
            self.selectedRouteStations = Array(fullRouteStations[startDistance...finishDistance])
        }
        
    }
}

extension FullRouteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullRouteStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fullRouteCell, for: indexPath)!
        cell.configure(with: fullRouteStations, row: indexPath.row, route: interactor.route, selectedRoute: selectedRouteStations)
        return cell
    }
}
