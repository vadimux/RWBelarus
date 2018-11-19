//
//  SettingsViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/19/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

protocol SettingsViewControllerInteractor: class {
    func countSettings() -> Int
    func showInfoCells(indexPath: IndexPath) -> String
}

protocol SettingsViewControllerCoordinator: class {
    func showActivitity(for index: Int)
    func callSocial(tag: Int)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingTableView: UITableView!
    
    var interactor: SettingsViewControllerInteractor!
    var coordinator: SettingsViewControllerCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            self.navigationItem.title = version + " (\(build))"
        }
    }
    
    @IBAction func socialButtonPressed(_ sender: UIButton) {
        coordinator?.callSocial(tag: sender.tag)
    }

}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.countSettings()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingCell, for: indexPath)!
        cell.configureWith(text: interactor.showInfoCells(indexPath: indexPath), index: indexPath.row)
        cell.tapped = { idx in
            self.coordinator?.showActivitity(for: idx)
        }
        return cell
    }
}
