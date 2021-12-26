//
//  ConfigServiceProvider.swift
//  GithubRepo
//
//  Created by admin on 12/11/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol ConfigServiceProtocol {
    func loadBackdropImage(for path: String) -> Single<UIImage?>
    func loadPoster(for path: String) -> Single<UIImage?>
}

final class ConfigServiceProvider: ConfigServiceProtocol {
    func loadBackdropImage(for path: String) -> Single<UIImage?> {
        let requestType = MovieAPI.backdropImage(path: path)
        return loadImage(for: requestType)
    }
    
    func loadPoster(for path: String) -> Single<UIImage?> {
        let requestType = MovieAPI.backdropImage(path: path)
        return loadImage(for: requestType)
    }
    
    func loadImage(for requestType: RequestableAPI) -> Single<UIImage?> {
        let path = requestType.urlRequest!
        return Single.create { single in
            URLSession.shared.dataTask(with: path.url!) { data, response, error in
                guard let resp = response as? HTTPURLResponse else {
                    return
                }
                
                if resp.statusCode >= 200 && resp.statusCode <= 300 {
                    guard let image = UIImage(data: data!) else {
                      return
                    }
                    
                    single(.success(image))
                }
            }.resume()
            return Disposables.create()
        }
    }
}
