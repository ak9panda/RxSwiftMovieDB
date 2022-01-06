//
//  MovieNetworkClient.swift
//  GithubRepo
//
//  Created by admin on 22/10/2021.
//

import Foundation
import RxSwift

protocol MovieNetworkClientProtocol {
    func fetchMovies() -> Observable<[MoviesSection]>
    func fetchPopularMovies() -> Observable<[MovieInfoResponse]>
    func fetchTopRatedMovies() -> Observable<[MovieInfoResponse]>
    func fetchNowPlayingMovies() -> Observable<[MovieInfoResponse]>
    func fetchUpcomingMovies() -> Observable<[MovieInfoResponse]>
}

class MovieNetworkClient: APIClient, MovieNetworkClientProtocol {
    
    static let shared = MovieNetworkClient()
    
    func fetchMovies() -> Observable<[MoviesSection]> {
        let popular = fetchPopularMovies().map {
            MoviesSection(header: CategoryTitle.popular.rawValue, movies: $0)
        }
        let toprated = fetchTopRatedMovies().map {
            MoviesSection(header: CategoryTitle.topRated.rawValue, movies: $0)
        }
        let upcoming = fetchUpcomingMovies().map {
            MoviesSection(header: CategoryTitle.upcoming.rawValue, movies: $0)
        }
        let nowplaying = fetchNowPlayingMovies().map {
            MoviesSection(header: CategoryTitle.nowPlaying.rawValue, movies: $0)
        }
        return Observable.zip(popular, toprated, upcoming, nowplaying)
            .map { [$0, $1, $2, $3] }
    }
    
    func fetchPopularMovies() -> Observable<[MovieInfoResponse]> {
        let requestType = MovieAPI.popularMovies
            
        let data: Observable<MovieListResponse> = self.execute(requestType: requestType)
            .observe(on: MainScheduler.instance)
        return data.map { $0.results }
    }
    
    func fetchTopRatedMovies() -> Observable<[MovieInfoResponse]> {
        let requestType = MovieAPI.nowplayingMovies
        
        let data: Observable<MovieListResponse> = self.execute(requestType: requestType)
            .observe(on: MainScheduler.instance)
        return data.map { $0.results }
    }
    
    func fetchUpcomingMovies() -> Observable<[MovieInfoResponse]> {
        let requestType = MovieAPI.upcomingMovies
        
        let data: Observable<MovieListResponse> = self.execute(requestType: requestType)
            .observe(on: MainScheduler.instance)
        return data.map { $0.results }
    }
    
    func fetchNowPlayingMovies() -> Observable<[MovieInfoResponse]> {
        let requestType = MovieAPI.nowplayingMovies
        
        let data: Observable<MovieListResponse> = self.execute(requestType: requestType)
            .observe(on: MainScheduler.instance)
        return data.map { $0.results }
    }
}



//    func fetchPopularMoviesRx() -> Observable<[MovieInfoResponse]> {
//        let route = URL(string: "\(Routes.ROUTE_POPULAR_MOVIES)&page=1")!
//        return Observable.create { observer -> Disposable in
//            let task = URLSession.shared.dataTask(with: route) { (data, response, error) in
//                guard let result: (Result<MovieListResponse, Error>) = self.responseHandler(data: data, urlResponse: response, error: error) else {
//                    return
//                }
//                switch result {
//                case .success(let movies):
//                    observer.onNext(movies.results)
//                    observer.onCompleted()
//                case .failure(let error):
//                    observer.onError(error)
//                }
//            }
//            task.resume()
//            return Disposables.create {
//                task.cancel()
//            }
//        }
//    }
