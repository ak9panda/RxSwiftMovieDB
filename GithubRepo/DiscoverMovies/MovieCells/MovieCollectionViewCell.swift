//
//  MovieCollectionViewCell.swift
//  GithubRepo
//
//  Created by admin on 25/10/2021.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var imgLoadingIndicator: UIActivityIndicatorView!
    
    private let loadingImageSubject = PublishSubject<Bool>()
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Overriden functions
    override func prepareForReuse() {
      super.prepareForReuse()
      disposeBag = DisposeBag()
    }
    
    func setData(poster: String, service: ConfigServiceProtocol) {
        disposeBag.insert {
            Observable.just(poster)
                .do(onNext: { _ in self.loadingImageSubject.onNext(true) })
                .compactMap { $0 }
                .flatMapLatest { imgPath in
                    service.loadPoster(for: imgPath)
                }
                .do(onNext: { _ in self.loadingImageSubject.onNext(false) })
                .asDriver(onErrorJustReturn: nil)
                .drive(self.imgPoster.rx.image)
                    
            loadingImageSubject.distinctUntilChanged()
                    .asDriver(onErrorJustReturn: false)
                    .drive(imgLoadingIndicator.rx.isAnimating)
        }
        
                
//        loadingImageSubject.distinctUntilChanged().subscribe(onNext: { [weak self] status in
//            if self?.imgLoadingIndicator.isAnimating == status {
//                self?.imgLoadingIndicator.startAnimating()
//            } else {
//                self?.imgLoadingIndicator.stopAnimating()
//            }
//        }).disposed(by: disposeBag)
    }
}
