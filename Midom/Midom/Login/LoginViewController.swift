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
        }
    }
    
    func update(errorMessage: String) {
        spinner.stopAnimating()
        self.view.makeToast(errorMessage)
    }
}
