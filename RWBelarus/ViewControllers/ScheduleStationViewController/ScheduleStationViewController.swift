//
//  ScheduleStationViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/8/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit
import Foundation
import Toast_Swift
import Hero

protocol ScheduleStationViewControllerInteractor: class {
    
    var fromData: AutocompleteAPIElement? { get set }
    func getSchedule(for station: String, date: String, completion: @escaping (_ route: [Route]?, _ error: String?) -> Void)
}

protocol ScheduleStationViewControllerCoordinator: class {
    
    func showStationsList(vc: UIViewController, for typeView: DirectionViewType?)
    func showCalendar(currentDate: Date, completion: @escaping (_ selectedDate: Date) -> Void)
    func showFullRoute(vc: UIViewController, for route: Route)
}

class ScheduleStationViewController: UIViewController {
    
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton! {
        didSet {
            scheduleButton.isEnabled = false
        }
    }
    @IBOutlet weak var stationLabel: UILabel!
    
    var interactor: ScheduleStationViewControllerInteractor!
    var coordinator: ScheduleStationViewControllerCoordinator?
    
    var trainList = [Route]()
    private var date: String = "everyday"
    private var selectedStation: String?
    private let heroTransition = HeroTransition()
    private var observer: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        self.navigationController?.hero.navigationAnimationType = .fade
        
        observer = stationLabel.observe(\.text, options: [.new]) { (_, change) in
            if change.newValue != nil {
                self.scheduleButton.isEnabled = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let fromData = interactor.fromData {
            stationLabel.text = fromData.value?.uppercased()
            selectedStation = fromData.value
        }
    }
    
    deinit {
        observer?.invalidate()
    }
    
    @IBAction func scheduleButtonTapped(_ sender: Any) {
        guard let selectedStation = selectedStation else { return }
        prepareResultForTableView(station: selectedStation)
    }
    
    @IBAction func tappedOnView(_ sender: Any) {
        coordinator?.showStationsList(vc: self, for: .fromView)
    }
    
    @IBAction func todayTapped(_ sender: Any) {
        configureDateButton(with: RouteDate.today)
    }
    
    @IBAction func tomorrowTapped(_ sender: Any) {
        configureDateButton(with: RouteDate.tomorrow)
    }
    
    @IBAction func everydayTapped(_ sender: Any) {
        configureDateButton(with: RouteDate.everyday)
    }
    
    private func configureDateButton(with date: RouteDate) {
        self.dateButton.setTitle(date.value, for: .normal)
        self.date = date.rawValue
    }
    
    private func prepareResultForTableView(station: String) {
        
        self.scheduleTableView.makeToastActivity(.center)
        self.scheduleTableView.hideEmptyCells()
        
        interactor.getSchedule(for: station, date: self.date) { [weak self] result, error in
            if error != nil {
                self?.scheduleTableView.hideToastActivity()
                self?.view.makeToast(error, duration: 3.0, position: .center)
                return
            }
            self?.trainList = result ?? []
            guard let count = result?.count, count > 0 else {
                self?.scheduleTableView.hideToastActivity()
                return
            }
            DispatchQueue.main.async {
                self?.scheduleTableView.hideToastActivity()
                self?.scheduleTableView.reloadData()
            }
        }
    }
}

extension ScheduleStationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.stationScheduleCell, for: indexPath)!
        let route = trainList[indexPath.row]
        cell.configure(with: route)
        cell.tapped = { [weak self] model in
            guard let `self` = self else { return }
            self.coordinator?.showFullRoute(vc: self, for: model)
        }
        return cell
    }
}

extension ScheduleStationViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            return heroTransition.navigationController(navigationController, interactionControllerFor: animationController)
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return heroTransition.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }
}
