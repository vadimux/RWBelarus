//
//  DialogViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/26/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit

class DialogViewController: UINavigationController {
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.modalPresentationStyle = .overFullScreen
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configViews()
    }
    
    private func configViews() {
        
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 44))
        backButton.setImage(R.image.crossIcon(), for: .normal)
        backButton.tintColor = UIColor.red
        backButton.setAttributedTitle("Отмена".localized.attributedRegularStringWithSize(16, color: UIColor(rgb: 0x36608A)), for: .normal)
        backButton.addTarget(self, action: #selector(cancelActionHandler), for: .touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        backButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        let backButtonItem = UIBarButtonItem.init(customView: backButton)
        
        topViewController?.navigationItem.setLeftBarButton(backButtonItem, animated: true)
        navigationBar.barTintColor = .white
    }
    
    @objc private func cancelActionHandler() {
        guard let rootViewController = self.viewControllers.first else { return }
        switch rootViewController {
        case is CalendarViewController:
            (rootViewController as? CalendarViewController)?.coordinator?.applyPeriodFromDate(nil, endDate: nil)
            self.dismiss(animated: true) {
                
            }
        case is CarriageSchemeViewController:
            (rootViewController as? CarriageSchemeViewController)?.coordinator?.dismiss()
            self.dismiss(animated: true) {
                
            }
        default:
            return
        }
    }
    
    public override func popViewController(animated: Bool) -> UIViewController? {
        let controller = super.popViewController(animated: animated)
        if self.children.count == 1 {
            cancelActionHandler()
        }
        return controller
    }
    
    public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return super.popToRootViewController(animated: animated)
    }
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
}
