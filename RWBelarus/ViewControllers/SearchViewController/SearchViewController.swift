//
//  SearchViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/15/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit
import Toast_Swift
import Hero

enum RouteDate: String {
    case today
    case tomorrow
    case everyday
    
    var value: String {
        switch self {
        case .today:
            return "сегодня".localized
        case .tomorrow:
            return "завтра".localized
        case .everyday:
            return "на все дни".localized
        }
    }
}

enum DirectionViewType {
    case toView
    case fromView
}

protocol SearchViewControllerInteractor: class {
    var fromData: AutocompleteAPIElement? { get set }
    var toData: AutocompleteAPIElement? { get set }
}

protocol SearchViewControllerCoordinator: class {
    func showResult(vc: UIViewController, from: AutocompleteAPIElement, to: AutocompleteAPIElement, date: String)
    func showStationsList(vc: UIViewController, for typeView: DirectionViewType?)
    func showCalendar(currentDate: Date, completion: @escaping (_ selectedDate: Date) -> Void)
}

class SearchViewController: UIViewController {
    
    var interactor: SearchViewControllerInteractor!
    var coordinator: SearchViewControllerCoordinator?
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var additionalFromLabel: UILabel! {
        didSet {
            additionalFromLabel.isHidden = true
        }
    }
    @IBOutlet weak var additionalToLabel: UILabel! {
        didSet {
            additionalToLabel.isHidden = true
        }
    }
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton! {
        didSet {
            searchButton.isEnabled = false
        }
    }
    
    var directionView: DirectionViewType?
    
    private let heroTransition = HeroTransition()
    private var isChangeDirectionTapped = false
    private var routeElements = [AutocompleteAPIElement?](repeating: nil, count: 2) //[from, to]
    private var date: String = "everyday"
    private var observerFromLabel: NSKeyValueObservation?
    private var observerToLabel: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.delegate = self
        self.navigationController?.hero.navigationAnimationType = .fade
        
        observerFromLabel = fromLabel.observe(\.text, options: [.new]) { (_, change) in
            if change.newValue != nil {
                let countEmpty = self.routeElements.reduce(0) { $1 == nil ? $0 + 1 : $0 }
                self.searchButton.isEnabled = countEmpty == 1 || countEmpty == 0 ? true : false
            }
        }
        observerToLabel = toLabel.observe(\.text, options: [.new]) { (_, change) in
            if change.newValue != nil {
                let countEmpty = self.routeElements.reduce(0) { $1 == nil ? $0 + 1 : $0 }
                self.searchButton.isEnabled = countEmpty == 1 || countEmpty == 0 ? true : false
            }
        }
        
        if #available(iOS 10.3, *) {
            RateManager.showRatesController()
        }
    }
    
    deinit {
        observerFromLabel?.invalidate()
        observerToLabel?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let fromData = interactor.fromData {
            additionalFromLabel.isHidden = false
            fromLabel.text = fromData.value?.uppercased()
            routeElements[0] = fromData
        }
        if let toData = interactor.toData {
            additionalToLabel.isHidden = false
            toLabel.text = toData.value?.uppercased()
            routeElements[1] = toData
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let fromAddress = self.interactor.fromData, let toAddress = self.interactor.toData else {
            self.view.makeToast("error")
            return
        }
        CoreDataManager.shared().saveRouteWith(from: fromAddress, to: toAddress)
        coordinator?.showResult(vc: self, from: fromAddress, to: toAddress, date: self.date)
    }
    
    @IBAction func tapOnView(_ sender: Any) {
        if let info = sender as? UITapGestureRecognizer {
            directionView = info.view == fromView ? .fromView : .toView
            coordinator?.showStationsList(vc: self, for: directionView)
        }
    }

    @IBAction func changeDirectionTapped(_ sender: Any) {
        
        isChangeDirectionTapped = !isChangeDirectionTapped
        let countEmpty = routeElements.reduce(0) { $1 == nil ? $0 + 1 : $0 }

        switch countEmpty {
        case 0:
            if isChangeDirectionTapped {
                fromLabel.text = routeElements[1]?.value?.uppercased()
                toLabel.text = routeElements[0]?.value?.uppercased()
                interactor.fromData = routeElements[1]
                interactor.toData = routeElements[0]
            } else {
                fromLabel.text = routeElements[0]?.value?.uppercased()
                toLabel.text = routeElements[1]?.value?.uppercased()
                interactor.fromData = routeElements[0]
                interactor.toData = routeElements[1]
            }
        case 1:
            if routeElements[0]?.value != nil {
                interactor.toData = routeElements[0]
                interactor.fromData = nil
                
                additionalFromLabel.isHidden = true
                fromLabel.text = "Откуда".localized
                additionalToLabel.isHidden = false
                toLabel.isHidden = false
                
                toLabel.text = routeElements[0]?.value?.uppercased()
                routeElements[1] = routeElements[0]
                routeElements[0] = nil
            } else {
                interactor.fromData = routeElements[1]
                interactor.toData = nil
                
                additionalFromLabel.isHidden = false
                fromLabel.isHidden = false
                additionalToLabel.isHidden = true
                toLabel.text = "Куда".localized
                
                fromLabel.text = routeElements[1]?.value?.uppercased()
                routeElements[0] = routeElements[1]
                routeElements[1] = nil
            }
            isChangeDirectionTapped = false
        default:
            return
        }
    }
    
    @IBAction func calendarTapped(_ sender: Any) {
        coordinator?.showCalendar(currentDate: Date()) { [weak self] date in
            guard let `self` = self else { return }
            let newDate = Date.format(date: date, dateFormat: Date.LABEL_DATE_FORMAT)
            let searchDate = Date.format(date: date, dateFormat: Date.COMMON_DATE_FORMAT)
            self.dateButton.setTitle(newDate, for: .normal)
            self.date = searchDate
        }
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

}

extension SearchViewController: UINavigationControllerDelegate {
    
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
