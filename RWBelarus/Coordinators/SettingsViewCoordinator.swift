//
//  SettingsViewCoordinator.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/19/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class SettingsViewCoordinator: NSObject, Coordinator, SettingsViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start(with completion: CoordinatorCallback?) {
        
    }
    
    func stop(with completion: CoordinatorCallback?) {
        
    }
    
    // Select social network
    func callSocial(tag: Int) {
        
        let url: URL? = {
            switch tag {
            case 0:
                return URL(string: "https://vk.com/rwbelarus")
            case 1:
                return URL(string: "https://www.facebook.com/rwbelarus")
            case 2:
                return URL(string: "https://www.instagram.com/rwbelarus/")
            default:
                return nil
            }
        }()
        
        guard let openURL = url else { return }
        UIApplication.shared.openURL(openURL)
    }
    
    func showActivitity(for index: Int) {
        
        switch index {
        // Send e-mail
        case 0:
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["vadimux@yandex.by"])
            mailVC.setSubject("Message from RWBelarus iOS App")
            mailVC.setMessageBody("Добавьте Ваш текст сообщения сюда".localized, isHTML: false)
            
            // Checking the Availability of the Composition Interface
            guard MFMailComposeViewController.canSendMail() else { return }
            rootViewController.present(mailVC, animated: false, completion: nil)
        // Share link
//        case 2:
//            let message = "Неофициальное iOS приложение расписания поездов Белорусской железной дороги".localized
//            guard let link = NSURL(string: "https://www.zippybus.com/") else { return }
//            
//            let objectsToShare = [message, link] as [Any]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//            activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
//            rootViewController.present(activityVC, animated: true, completion: nil)
        default: return
        }
    }
}

// MARK: MFMailComposeViewControllerDelegate
extension SettingsViewCoordinator: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
