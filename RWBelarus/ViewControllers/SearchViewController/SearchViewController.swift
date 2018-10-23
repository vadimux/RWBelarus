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
    func showResult(vc: UIViewController, from: AutocompleteAPIElement?, to: AutocompleteAPIElement?)
    func showStation(vc: UIViewController)
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
    
    fileprivate let heroTransition = HeroTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        self.hideKeyboardWhenTappedAround()
        
        self.navigationController?.delegate = self
        self.navigationController?.hero.navigationAnimationType = .fade
    }
    
    private func configureUI() {
        fromLabel.text = "1".localized
        toLabel.text = "2".localized
        additionalFromLabel.isHidden = true
        additionalToLabel.isHidden = true
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        coordinator?.showResult(vc: self, from: self.interactor.fromData, to: self.interactor.toData)
    }
    
    @IBAction func tapOnView(_ sender: Any) {
        
        if let info = sender as? UITapGestureRecognizer {
            
            if info.view?.tag == 0 {
                print("from")
                coordinator?.showStation(vc: self)
            } else {
                print("to")
            }
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
