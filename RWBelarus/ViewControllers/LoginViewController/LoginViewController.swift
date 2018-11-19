//
//  LoginViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 11/16/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit

protocol LoginViewControllerInteractor: class {
    func loginWith(_ login: String, password: String, completion: @escaping (_ result: String?, _ error: String?) -> Void)
}

protocol LoginViewControllerCoordinator: class {
    func showPersonalArea()
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var infoLabel: UILabel!
    var interactor: LoginViewControllerInteractor!
    var coordinator: LoginViewControllerCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func loginButtonTapped(_ sender: Any) {
//        "vadimux", password: "1427nm1w"
//        guard let login = loginTextField.text, let password = passwordTextField.text else { return }
        interactor.loginWith("", password: "") { result, error in
            print(result, error)
            self.infoLabel.text = error != nil ? error : result
        }
    }
}
