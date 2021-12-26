//
//  MoviesViewModel.swift
//  GithubRepo
//
//  Created by admin on 07/11/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieViewModelProtocol {
    var dataSource: Driver<[MoviesSection]> { get }
    var movieDetail: Driver<MovieInfoResponse> { get }
    
    func bindLoadMovies(to observable: Observable<Void>) -> Disposable
    func bindLoadMovieDetail(to observable: Observable<MovieInfoResponse>) -> Disposable
}

struct MoviesViewModel {
    
    let movieService: MovieNetworkClientProtocol
    private let dataSourceRelay = BehaviorRelay<[MoviesSection]>(value: [])
    private let didReceiveMovieDetailSubject = PublishSubject<MovieInfoResponse>()
    
    init(service: MovieNetworkClient = MovieNetworkClient()) {
        self.movieService = service
    }
}

// MARK: - MoviesViewModelType
extension MoviesViewModel: MovieViewModelProtocol {
    
    var dataSource: Driver<[MoviesSection]> {
        dataSourceRelay.asDriver()
    }
    
    var movieDetail: Driver<MovieInfoResponse> {
        didReceiveMovieDetailSubject.asDriver(onErrorDriveWith: .empty())
    }
    
    func bindLoadMovies(to observable: Observable<Void>) -> Disposable {
        let share = observable.share()
        
        return share
            .flatMapLatest{ self.requestMovies() }
            .bind(to: dataSourceRelay)
    }
    
    func bindLoadMovieDetail(to observable: Observable<MovieInfoResponse>) -> Disposable {
        observable
            .bind(to: didReceiveMovieDetailSubject)
    }
    
}

// MARK: - Setup observables
extension MoviesViewModel {
    func requestMovies() -> Single<[MoviesSection]> {
        movieService.fetchMovies()
            .take(1)
            .asSingle()
    }
//
//    func requestMovieDetail() -> Observable<MovieInfoResponse> {
//
//    }
}



