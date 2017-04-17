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

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = HomeViewController()
        let nc = UINavigationController(rootViewController: viewController)
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        
        window?.backgroundColor = .white
        
        return true
    }

}

