//
//  AppDelegate.swift
//  GithubRepo
//
//  Created by admin on 14/09/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            let _ = AppNavigation(window: window)
        }
        window?.makeKeyAndVisible()
        
        return true
    }
}

