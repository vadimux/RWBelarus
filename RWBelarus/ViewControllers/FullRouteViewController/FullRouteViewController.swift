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
    func dismiss()
}

class FullRouteViewController: UIViewController {
    
    @IBOutlet weak var fullRouteTableView: UITableView!
    @IBOutlet weak var trainTypeImage: UIImageView!
    @IBOutlet weak var trainNumberLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var trainTypeLabel: UILabel!
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    var interactor: FullRouteViewControllerInteractor!
    weak var coordinator: FullRouteViewControllerCoordinator?
    
    private var fullRouteStations = [RouteItem]()
    private var selectedRouteStations = [RouteItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForShow()
        self.title = interactor?.prepareForTitle()
        
        self.fullRouteTableView.makeToastActivity(.center)
        interactor.fetchFullRoute { [weak self] result, error in
            guard let `self` = self else { return }
            if error != nil {
                self.fullRouteTableView.hideToastActivity()
                self.view.makeToast(error, duration: 3.0, position: .center)
                self.fullRouteTableView.backgroundView?.isHidden = false
                self.topConstraint.constant = self.topViewHeightConstraint.constant + 44
                return
            }
            if result?.isEmpty == true || result == nil {
                self.fullRouteTableView.reloadData()
                self.fullRouteTableView.backgroundView?.isHidden = false
                self.topConstraint.constant = self.topViewHeightConstraint.constant + 44
                self.fullRouteTableView.hideToastActivity()
                return
            }
            self.fullRouteStations = result ?? []
            self.createSelectedRoute()
            self.fullRouteTableView.reloadData()
            self.fullRouteTableView.hideToastActivity()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            self.coordinator?.dismiss()
        }
    }
    
    func prepareForShow() {
        
        fullRouteTableView.backgroundView = emptyView
        fullRouteTableView.backgroundView?.isHidden = true
        
        self.trainNumberLabel.text = self.interactor.route.trainId
        self.routeLabel.text = self.interactor.route.routeName
        self.trainTypeLabel.text = self.interactor.route.trainType.rawValue
        self.trainTypeImage.image = {
            UIImage.configureImage(for: self.interactor.route.trainType)
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
