//
//  DiscoverMoviesNavigation.swift
//  GithubRepo
//
//  Created by admin on 11/01/2022.
//

import Foundation
import UIKit

struct DiscoverMoviesNavigation {
    
    let discoverMoviesNavigationController: UINavigationController
    
    init(storyboard: UIStoryboard) {
        discoverMoviesNavigationController = UINavigationController()
        let discover = storyboard.instantiateViewController(identifier: "MoviesViewController") as! MoviesViewController
        discoverMoviesNavigationController.viewControllers = [discover]
    }
}
