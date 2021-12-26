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
    let movieService: MovieNetworkClientProtocol
    
    init(service: MovieNetworkClient = MovieNetworkClient()) {
        self.movieService = service
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
            .flatMapLatest { self.requestMovies(by: "") }
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
    
    func bindMovieList(to observable: Observable<String>) -> Disposable {
        observable
            .map { $0 }
            .flatMapLatest { self.requestMovies(by: $0) }
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
        movieService.fetchUpcomingMovies()
            .take(1)
            .asSingle()
    }
}
