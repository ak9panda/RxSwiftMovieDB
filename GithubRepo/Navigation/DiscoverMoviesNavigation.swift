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
    let storyboard: UIStoryboard
    
    init(storyboard: UIStoryboard) {
        discoverMoviesNavigationController = UINavigationController()
        self.storyboard = storyboard
        let discover = self.storyboard.instantiateViewController(identifier: "MoviesViewController") as! MoviesViewController
        discover.didSelectMovie = didSelectMovieDetail(viewModel:)
        discover.didSelectSeemore = didSelectSeeMore(category:)
        discoverMoviesNavigationController.viewControllers = [discover]
    }
    
    private func didSelectMovieDetail(viewModel: MovieDetailViewModelProtocol) {
        let detailVC = self.storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        detailVC.setup(viewModel: viewModel)
        detailVC.hidesBottomBarWhenPushed = true
        self.discoverMoviesNavigationController.pushViewController(detailVC, animated: true)
    }
    
    private func didSelectSeeMore(category: String) {
        let movieListVC = self.storyboard.instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
        movieListVC.didSelectMovie = didSelectMovieDetail(viewModel:)
        movieListVC.category = category
        movieListVC.hidesBottomBarWhenPushed = true
        self.discoverMoviesNavigationController.pushViewController(movieListVC, animated: true)
    }
}
