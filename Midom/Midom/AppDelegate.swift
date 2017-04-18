//
//  AppDelegate.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let context = AppContext()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let window = context.window
        window.makeKeyAndVisible()
        window.frame = UIScreen.main.bounds
        window.becomeKey()
        window.backgroundColor = .white

        context.navigationService.showLogin()
        
        return true
    }

}

