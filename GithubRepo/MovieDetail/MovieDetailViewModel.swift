//
//  MovieDetailViewModel.swift
//  GithubRepo
//
//  Created by admin on 09/11/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol MovieDetailViewModelProtocol {
    var backdropImage: Driver<UIImage?> { get }
    var posterImage: Driver<UIImage?> { get }
    var title: Driver<String?> { get }
    var releaseYear: Driver<String?> { get }
    var runtime: Driver<String?> { get }
    var overview: Driver<String?> { get }
}

struct MovieDetailViewModel {
    private let model: MovieInfoResponse
    private let service: ConfigServiceProtocol
    private let disposeBag = DisposeBag()
    private let openHomePageSubject = PublishSubject<String>()
    
    init(model: MovieInfoResponse, service: ConfigServiceProtocol = ConfigServiceProvider()) {
        self.model = model
        self.service = service
    }
}

extension MovieDetailViewModel: MovieDetailViewModelProtocol {
    
    var backdropImage: Driver<UIImage?> {
        Observable.just(model.backdrop_path)
          .compactMap { $0 }
          .flatMapLatest {
            self.service.loadBackdropImage(for: $0)
          }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var posterImage: Driver<UIImage?> {
        Observable.just(model.poster_path)
            .compactMap { $0 }
            .flatMapLatest {
                self.service.loadPoster(for: $0)
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var title: Driver<String?> {
        .just(model.title)
    }
    
    var releaseYear: Driver<String?> {
        let year = model.release_date?.split(separator: "-").first ?? "-"
        return .just(String(year))
    }
    
    var runtime: Driver<String?> {
        let runtime = model.runtime.map { formatTime(Double($0)) }
        return .just(runtime)
    }
    
    var overview: Driver<String?> {
        .just(model.overview)
    }
    
}

// MARK: Utility methods
private extension MovieDetailViewModel {
    func formatTime(_ movieRuntime: Double) -> String {
      guard movieRuntime > 60 else {
        return "\(Int(movieRuntime))m"
      }

      let totalHours = movieRuntime / 60
      let minutes = totalHours.truncatingRemainder(dividingBy: 1) * 60
      return "\(Int(totalHours))h \(Int(minutes))m"
    }
}
