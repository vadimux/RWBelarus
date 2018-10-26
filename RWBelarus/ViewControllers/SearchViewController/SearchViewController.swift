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

protocol SearchViewControllerInteractor: class {
    var fromData: AutocompleteAPIElement? { get set }
    var toData: AutocompleteAPIElement? { get set }
}

protocol SearchViewControllerCoordinator: class {
    func showResult(vc: UIViewController, from: AutocompleteAPIElement, to: AutocompleteAPIElement)
    func showStationsList(vc: UIViewController, for tagView: Int?)
    func showCalendar(currentDate: Date, completion: @escaping (_ selectedDate: Date) -> Void)
}

class SearchViewController: UIViewController {
    
    var interactor: SearchViewControllerInteractor!
    var coordinator: SearchViewControllerCoordinator?
    
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var additionalFromLabel: UILabel!
    @IBOutlet weak var additionalToLabel: UILabel!

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var infoStackView: UIStackView!
    
    private let heroTransition = HeroTransition()
    private var isChangeDirectionTapped = false
    private var routeElements = [AutocompleteAPIElement?](repeating: nil, count: 2) //[from, to]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.delegate = self
        self.navigationController?.hero.navigationAnimationType = .fade
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
    
    private func configureUI() {
        fromLabel.text = "Откуда".localized
        toLabel.text = "Куда".localized
        
        additionalFromLabel.isHidden = true
        additionalToLabel.isHidden = true
        self.hero.isEnabled = true
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let fromAddress = self.interactor.fromData, let toAddress = self.interactor.toData else {
            self.view.makeToast("error")
            return
        }
        coordinator?.showResult(vc: self, from: fromAddress, to: toAddress)
    }
    
    @IBAction func tapOnView(_ sender: Any) {
        if let info = sender as? UITapGestureRecognizer {
            coordinator?.showStationsList(vc: self, for: info.view?.tag)
        }
    }
    @IBAction func changeDirectionTapped(_ sender: Any) {
        
        isChangeDirectionTapped = !isChangeDirectionTapped
        let countEmpty = routeElements.reduce(0) { $1 == nil ? $0 + 1 : $0 }
        
        switch countEmpty {
        case 2:
            self.view.makeToast("error")
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
        default:
            return
        }
        
    }
    @IBAction func calendarTapped(_ sender: Any) {
        coordinator?.showCalendar(currentDate: Date()) { (date) in
            print(date)
        }
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
