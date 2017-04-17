//
//  HomeViewController.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Midom"
    }
    
    @IBAction func pendingClicked(_ sender: UIButton) {
        showListView(request: .pending)
    }
    
    @IBAction func acceptedClicked(_ sender: UIButton) {
        showListView(request: .accepted)
    }
    
    @IBAction func consultedClicked(_ sender: UIButton) {
        showListView(request: .consulted)
    }
    
    @IBAction func closedClicked(_ sender: UIButton) {
        showListView(request: .closed)
    }
    
    @IBAction func rejectedClicked(_ sender: UIButton) {
        showListView(request: .rejected)
    }
    
    @IBAction func revokedClicked(_ sender: UIButton) {
        showListView(request: .revoked)
    }
    
    @IBAction func settingsClicked(_ sender: UIButton) {
    
    }
    
    @IBAction func logoutClicked(_ sender: UIButton) {
        // TODO: clear db, user
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController =
            UINavigationController(rootViewController: LoginViewController())
    }
    
    private func showListView(request: RequestType) {
        navigationController?.pushViewController(
            RequestListViewController(requestType: request), animated: true)
    }
}
