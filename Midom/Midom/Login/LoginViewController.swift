//
//  LoginViewController.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let apiService = MidomPublicApi()

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        if let username = usernameField.text, let password = passwordField.text {
            apiService.login(username: username, password: password) { result in
                
                
            }
        }
        
    }

}
