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
import RxSwift
import RxCocoa
import RxGesture

enum RouteDate: String, CaseIterable {
    typealias BaseType = String
    case today, tomorrow, everyday
    
    func value() -> String {
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
    func configureSearchButtonState(with elements: [AutocompleteAPIElement?]) -> Int
}

protocol SearchViewControllerCoordinator: class {
    func showResult(vc: UIViewController, from: AutocompleteAPIElement, to: AutocompleteAPIElement, date: String)
    func showStationsList(vc: UIViewController, for typeView: DirectionViewType?)
    func showCalendar(currentDate: Date, completion: @escaping (_ selectedDate: Date) -> Void)
}

class SearchViewController: UIViewController {
    
    var interactor: SearchViewControllerInteractor!
    var coordinator: SearchViewControllerCoordinator?
    
    @IBOutlet weak var changeDirectionButton: UIButton!
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
    @IBOutlet weak var fromLabel: CapitalizedLabel!
    @IBOutlet weak var toLabel: CapitalizedLabel!
    
    @IBOutlet weak var searchButton: UIButton!

    private let heroTransition = HeroTransition()
    private var isChangeDirectionTapped = false
    private var routeElements = [AutocompleteAPIElement?](repeating: nil, count: 2) //[from, to]
    private var date: String = "everyday"
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeDirectionButton.rx.tap
          .subscribe(onNext: {
            self.configureDirection()
          })
          .disposed(by: bag)
        
        fromView.rx.gesture(.tap())
            .subscribe({ (event) in
                if event.element?.state == .ended {
                    self.coordinator?.showStationsList(vc: self, for: .fromView)
                }
            })
        .disposed(by: bag)
        
        toView.rx.gesture(.tap())
            .subscribe({ (event) in
                if event.element?.state == .ended {
                    self.coordinator?.showStationsList(vc: self, for: .toView)
                }
            })
        .disposed(by: bag)
        
        searchButton.rx.tap
        .subscribe(onNext: {
            guard let firstElement = self.routeElements.first, let fromAddress = firstElement,
                let lastElement = self.routeElements.last, let toAddress = lastElement else { return }
            CoreDataManager.shared().saveRouteWith(from: fromAddress, to: toAddress)
            self.coordinator?.showResult(vc: self, from: fromAddress, to: toAddress, date: self.date)
        })
        .disposed(by: bag)

        dateButton.rx.tap
        .subscribe(onNext: {
            self.coordinator?.showCalendar(currentDate: Date()) { [weak self] date in
                guard let `self` = self else { return }
                let newDate = Date.format(date: date, dateFormat: Date.LABEL_DATE_FORMAT)
                let searchDate = Date.format(date: date, dateFormat: Date.COMMON_DATE_FORMAT)
                self.dateButton.setTitle(newDate, for: .normal)
                self.date = searchDate
            }
        })
        .disposed(by: bag)

        self.hero.isEnabled = true
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.delegate = self
        self.navigationController?.hero.navigationAnimationType = .fade
        
        if #available(iOS 10.3, *) {
            RateManager.showRatesController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        var isFullDirection: BehaviorRelay<Bool>?
        let additionalFromLabelData = BehaviorRelay(value: interactor.fromData)
        let additionalToLabelData = BehaviorRelay(value: interactor.toData)
        
        additionalFromLabelData
            .subscribe({ (element) in
                guard let element = element.element, let autocompleteElement = element else { return }
                self.additionalFromLabel.isHidden = false
                self.fromLabel.text = autocompleteElement.value
                self.routeElements[0] = autocompleteElement
                isFullDirection = BehaviorRelay(value: self.interactor.configureSearchButtonState(with: self.routeElements) == 0)
            })
        .disposed(by: bag)
        
        additionalToLabelData
            .subscribe({ (element) in
                guard let element = element.element, let autocompleteElement = element else { return }
                self.additionalToLabel.isHidden = false
                self.toLabel.text = autocompleteElement.value
                self.routeElements[1] = autocompleteElement
                isFullDirection = BehaviorRelay(value: self.interactor.configureSearchButtonState(with: self.routeElements) == 0)
            })
        .disposed(by: bag)
        
        isFullDirection?.asObservable()
        .bind(to: searchButton.rx.isEnabled)
        .disposed(by: bag)
    }

    private func configureDirection() {
        
        isChangeDirectionTapped = !isChangeDirectionTapped
        let countEmpty = self.interactor.configureSearchButtonState(with: self.routeElements)

        switch countEmpty {
        case 0:
            fromLabel.text = routeElements[1]?.value
            toLabel.text = routeElements[0]?.value
            routeElements.swapAt(1, 0)
        case 1:
            if routeElements[0]?.value != nil {
                additionalFromLabel.isHidden = true
                fromLabel.text = "Откуда".localized
                additionalToLabel.isHidden = false
                toLabel.isHidden = false
                toLabel.text = routeElements[0]?.value
            } else {
                additionalFromLabel.isHidden = false
                fromLabel.isHidden = false
                additionalToLabel.isHidden = true
                toLabel.text = "Куда".localized
                fromLabel.text = routeElements[1]?.value
            }
            routeElements.swapAt(0, 1)
        default:
            return
        }
    }
    
    @IBAction func dayTapped(_ sender: Any) {
        guard let element = (sender as? UIButton)?.currentTitle, let selectedDayType = RouteDate.find(element) else { return }
        self.dateButton.setTitle(selectedDayType.value(), for: .normal)
        date = selectedDayType.rawValue
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
