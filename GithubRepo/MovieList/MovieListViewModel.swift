//
//  MovieListViewModel.swift
//  GithubRepo
//
//  Created by Aung Kyaw Phyo on 12/10/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieListViewModelType {
    var dataSource: Driver<[MovieInfoResponse]> { get }
    var errorMessage: Driver<String?> { get }
    var isLoadingData: Driver<Bool> { get }
    
    func bindLoadFirstPage(to observable: Observable<Void>) -> Disposable
    func bindLoadNextPage(to observable: Observable<Void>) -> Disposable
}

struct MovieListViewModel {
    
    private let dataSourceRelay = BehaviorRelay<[MovieInfoResponse]>(value: [])
    private let errorMessageSubject = PublishSubject<String?>()
    private let isLoadingDataSubject = PublishSubject<Bool>()
    private var page = BehaviorRelay(value: 1)
    var category = ""
    let movieService: MovieNetworkClientProtocol
    
    init(service: MovieNetworkClient = MovieNetworkClient(), category: String) {
        self.movieService = service
        self.category = category
    }
}

extension MovieListViewModel: MovieListViewModelType {
    
    var dataSource: Driver<[MovieInfoResponse]> {
        dataSourceRelay.asDriver()
    }
    
    var errorMessage: Driver<String?> {
        errorMessageSubject.asDriver(onErrorJustReturn: nil)
    }
    
    var isLoadingData: Driver<Bool> {
        isLoadingDataSubject.asDriver(onErrorJustReturn: false)
    }
    
    func bindLoadFirstPage(to observable: Observable<Void>) -> Disposable {
        let shared = observable.share()
        
        let resetPage = shared
            .map{ 1 }
            .bind(to: page)
        
        let requestMovie = shared
            .flatMapLatest { self.requestMovies(by: self.category) }
            .bind(to: dataSourceRelay)
        
        let resetDatasource = shared
            .map { [] }
            .bind(to: dataSourceRelay)
        
        return Disposables.create(resetPage, requestMovie, resetDatasource)
    }
    
    func bindLoadNextPage(to observable: Observable<Void>) -> Disposable {
        observable
            .flatMapLatest { self.requestMovies(by: "") }
            .bind(to: dataSourceRelay)
    }
    
    func bindMovieList(to observable: Observable<Void>) -> Disposable {
        observable
            .flatMapLatest { self.requestMovies(by: self.category) }
            .bind(to: dataSourceRelay)
    }
}

private extension MovieListViewModel {
    func requestMovies() -> Single<[MovieInfoResponse]> {
        movieService.fetchPopularMovies()
            .take(1)
            .asSingle()
    }
    
    func requestMovies(by category: String) -> Single<[MovieInfoResponse]> {
        
        var movies: Observable<[MovieInfoResponse]> = Observable.just([])
        if category == CategoryTitle.popular.rawValue {
            movies = movieService.fetchPopularMovies()
        }else if category == CategoryTitle.upcoming.rawValue {
            movies = movieService.fetchUpcomingMovies()
        }else if category == CategoryTitle.topRated.rawValue {
            movies = movieService.fetchTopRatedMovies()
        }else if category == CategoryTitle.nowPlaying.rawValue {
            movies = movieService.fetchNowPlayingMovies()
        }
        
        return movies.take(1).asSingle()
    }
}
