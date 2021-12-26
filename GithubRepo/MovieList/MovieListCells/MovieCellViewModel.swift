//
//  MovieCellViewModel.swift
//  GithubRepo
//
//  Created by Aung Kyaw Phyo on 11/29/21.
//

import RxSwift
import RxCocoa

protocol MovieCellViewModelType {
    var title: Driver<String?> { get }
    var ReleaseYear: Driver<String?> { get }
    var posterImage: Driver<UIImage?> { get }
    var popularity: Driver<String?> { get }
    var overview: Driver<String?> { get }
    var loadingImage: Driver<Bool> { get }
}

struct MovieCellViewModel {
    private var model: MovieInfoResponse
    private var loadingImageSubject = PublishSubject<Bool>()
    private var service: ConfigServiceProtocol
    
    init(model: MovieInfoResponse, service: ConfigServiceProtocol) {
        self.model = model
        self.service = service
    }
}

extension MovieCellViewModel: MovieCellViewModelType {
    
    var title: Driver<String?> {
        .just(model.title)
    }
    
    var ReleaseYear: Driver<String?> {
        let year = model.release_date?.split(separator: "-").first ?? "-"
        return .just(String(year))
    }
    
    var posterImage: Driver<UIImage?> {
        Observable.just(model.poster_path)
            .do(onNext: { _ in self.loadingImageSubject.onNext(true) })
            .compactMap {$0}
            .flatMapLatest {
                self.service
                    .loadPoster(for: $0)
                    .catch { _ in
                        return .just(nil)
                    }
            }
            .do(onNext: { _ in self.loadingImageSubject.onNext(false) })
            .asDriver(onErrorJustReturn: nil)
    }
    
    var popularity: Driver<String?> {
        guard let ratingScore = model.popularity else {
            return .just(nil)
        }
        
        let rating = String(format: "%.1f", ratingScore)
        return .just(rating)
    }
    
    var overview: Driver<String?> {
        .just(model.overview)
    }
    
    var loadingImage: Driver<Bool> {
        loadingImageSubject.asDriver(onErrorJustReturn: false)
    }
}
