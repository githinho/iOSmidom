//
//  NavigationService.swift
//  Midom
//
//  Created by Eugen Druzin on 17/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation
import UIKit

class NavigationService {
    
    private var window: UIWindow
    private var viewControllerFactory: ViewControllerFactory
    
    init(window: UIWindow, factory: ViewControllerFactory) {
        self.window = window
        self.viewControllerFactory = factory
    }
    
    func showLogin() {
        window.rootViewController = UINavigationController.init(
            rootViewController: viewControllerFactory.loginController())
    }
    
    func showHome() {
        window.rootViewController = UINavigationController.init(
            rootViewController: viewControllerFactory.homeController())
    }
    
    func showRequestList(viewController: UIViewController, type: RequestType) {
        viewController.navigationController?.pushViewController(
            viewControllerFactory.requestListController(type: type), animated: true)
    }
    
    func showPendingRequest(viewController: UIViewController, id: Int) {
        viewController.navigationController?.pushViewController(
            viewControllerFactory.pendingRequestController(id: id), animated: true)
    }
    
    func showAcceptedRequest(viewController: UIViewController, id: Int) {
        viewController.navigationController?.pushViewController(
            viewControllerFactory.accptedRequestController(id: id), animated: true)
    }
}
