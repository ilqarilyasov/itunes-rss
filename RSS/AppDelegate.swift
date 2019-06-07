//
//  AppDelegate.swift
//  RSS
//
//  Created by Ilgar Ilyasov on 6/7/19.
//  Copyright © 2019 IIIyasov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let rssTVC = RSSTableViewController()
        let navController = UINavigationController(rootViewController: rssTVC)
        window?.rootViewController = navController
        
        return true
    }
}

