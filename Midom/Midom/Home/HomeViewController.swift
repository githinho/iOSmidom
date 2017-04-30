//
//  HomeViewController.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private var service: MidomService
    private var navigationService: NavigationService
    
    init(navigationService: NavigationService, midomService: MidomService) {
        self.service = midomService
        self.navigationService = navigationService
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        service.logoutUser()
    }
    
    private func showListView(request: RequestType) {
        navigationService.showRequestList(viewController: self, type: request)
    }
}
