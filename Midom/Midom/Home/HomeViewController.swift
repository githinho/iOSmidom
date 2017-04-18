//
//  HomeViewController.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private var navigationService: NavigationService?
    
    convenience init(navigationService: NavigationService) {
        self.init()
        self.navigationService = navigationService
    }
    
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
        // TODO: clear db, user... use midomService
        navigationService?.showLogin()
    }
    
    private func showListView(request: RequestType) {
        navigationService?.showRequestList(viewController: self, type: request)
    }
}
