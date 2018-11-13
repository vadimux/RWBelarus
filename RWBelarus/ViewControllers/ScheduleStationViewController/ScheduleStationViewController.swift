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
    
    func showStationsList(vc: UIViewController, for tagView: Int?)
    func showCalendar(currentDate: Date, completion: @escaping (_ selectedDate: Date) -> Void)
    func showFullRoute(vc: UIViewController, for route: Route)
}

class ScheduleStationViewController: UIViewController {
    
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var stationLabel: UILabel!
    
    var interactor: ScheduleStationViewControllerInteractor!
    var coordinator: ScheduleStationViewControllerCoordinator?
    
    var trainList = [Route]()
    private var date: String!
    private let kObservedPropertyName = "text"
    private var selectedStation: String?
    private let heroTransition = HeroTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        self.navigationController?.hero.navigationAnimationType = .fade
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stationLabel.addObserver(self, forKeyPath: kObservedPropertyName, options: .new, context: nil)
        
        if let fromData = interactor.fromData {
            stationLabel.text = fromData.value?.uppercased()
            selectedStation = fromData.value
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stationLabel.removeObserver(self, forKeyPath: kObservedPropertyName)
    }
    
    private func configureUI() {
        
        stationLabel.text = "Cтанция".localized
        
        //by default
        self.dateButton.setTitle("на все дни".localized, for: .normal)
        self.date = "everyday"
        self.scheduleButton.isEnabled = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kObservedPropertyName {
            if let _ = change?[.newKey] {
                self.scheduleButton.isEnabled = stationLabel.text != nil
            }
        }
    }
    
    @IBAction func scheduleButtonTapped(_ sender: Any) {
        guard let selectedStation = selectedStation else { return }
        prepareResultForTableView(station: selectedStation)
    }
    
    @IBAction func tappedOnView(_ sender: Any) {
        if let info = sender as? UITapGestureRecognizer {
            coordinator?.showStationsList(vc: self, for: info.view?.tag)
        }
    }
    
    @IBAction func calendarTapped(_ sender: Any) {
        coordinator?.showCalendar(currentDate: Date()) { date in
            let newDate = Date.convertLabelDate(date: date)
            let searchDate = Date.convertSearchFormatDate(date: date)
            self.dateButton.setTitle(newDate, for: .normal)
            self.date = searchDate
        }
    }
    
    @IBAction func todayTapped(_ sender: Any) {
        self.dateButton.setTitle(RouteDate.today.value, for: .normal)
        self.date = RouteDate.today.rawValue
    }
    
    @IBAction func tomorrowTapped(_ sender: Any) {
        self.dateButton.setTitle(RouteDate.tomorrow.value, for: .normal)
        self.date = RouteDate.tomorrow.rawValue
    }
    
    @IBAction func everydayTapped(_ sender: Any) {
        self.dateButton.setTitle(RouteDate.everyday.value, for: .normal)
        self.date = RouteDate.everyday.rawValue
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
        cell.tapped = { model in
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
