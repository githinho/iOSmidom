//
//  AppContext.swift
//  Midom
//
//  Created by Eugen Druzin on 17/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerFactory {
    func loginController() -> LoginViewController
    func homeController() -> HomeViewController
    func requestListController(type: RequestType) -> RequestListViewController
}

class AppContext: ViewControllerFactory, PresenterContext {
    
    private(set) lazy var window = UIWindow()
    private(set) lazy var navigationService: NavigationService = NavigationService(window:self.window, factory: self)
    
    private lazy var renderer: Renderer = Renderer(window: self.window, context: self)
    private lazy var apiService = MidomApi()
    internal lazy var midomService: MidomService =
        MidomService(
            midomApi: self.apiService,
            navigationService: self.navigationService,
            signal: self.renderer.render)
    
    func loginController() -> LoginViewController {
        return LoginViewController(midomService: midomService)
    }
    
    func homeController() -> HomeViewController {
        return HomeViewController(navigationService: navigationService)
    }
    
    func requestListController(type: RequestType) -> RequestListViewController {
        return RequestListViewController(requestType: type)
    }
}
