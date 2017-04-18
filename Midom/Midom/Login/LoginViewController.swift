//
//  LoginViewController.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit
import Toast_Swift

class LoginViewController: UIViewController {
    
    private var midomService: MidomService?

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    convenience init(midomService: MidomService) {
        self.init()
        self.midomService = midomService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        spinner.startAnimating()
        if let username = usernameField.text, let password = passwordField.text {
            midomService?.loginUser(username: username, password: password)
            
//            apiService?.login(username: username, password: password) { [weak self] result in
//                guard let `self` = self else { return }
//                switch result {
//                case .success(_):
//                    // TODO: save username and password
//                    self.present(HomeViewController(), animated: true, completion: nil)
//                    break
//                case .failure(let message):
//                    self.spinner.stopAnimating()
//                    self.view.makeToast(message)
//                }
//            }
        }
    }
    
    func update(errorMessage: String) {
        spinner.stopAnimating()
        self.view.makeToast(errorMessage)
    }
}
