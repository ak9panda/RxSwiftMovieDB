//
//  AppNavigation.swift
//  GithubRepo
//
//  Created by admin on 11/01/2022.
//

import Foundation
import UIKit

struct AppNavigation {
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    init(window: UIWindow) {
        
        let discover = DiscoverMoviesNavigation(storyboard: mainStoryboard).discoverMoviesNavigationController
        
        let tabBarController = UITabBarController()
        tabBarController.hidesBottomBarWhenPushed = true
        tabBarController.setViewControllers([
            discover
        ], animated: true)
        
        tabBarController.tabBar.barTintColor = .systemBackground
        tabBarController.tabBar.tintColor = .label
        tabBarController.tabBar.items![0].title = "Discover"
        
        window.rootViewController = tabBarController
    }
}
