//
//  APIClient.swift
//  GithubRepo
//
//  Created by admin on 22/10/2021.
//

import Foundation
import RxSwift
import RxCocoa


class APIClient {
    
    func responseHandler<T>(data: Data?, urlResponse: URLResponse?, error: Error?) -> Result<T, Error>? where T: Decodable {
        
        let response = urlResponse as! HTTPURLResponse
        
        if response.statusCode >= 200 && response.statusCode <= 300 {
            guard let data = data else {
                return .failure(error!)
            }
            
            if let result = try? JSONDecoder().decode(T.self, from: data) {
                return .success(result)
            }else {
                return .failure(error!)
            }
        }else {
            return .failure(error!)
        }
    }
    
    func execute<T>(requestType: RequestableAPI) -> Observable<T> where T: Decodable {
        let url = requestType.urlRequest!
        return Observable.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                guard let resp = response as? HTTPURLResponse else {
                    return
                }
                
                if resp.statusCode >= 200 && resp.statusCode <= 300 {
                    guard let data = data, let decoded = try? JSONDecoder().decode(T.self, from: data) else{
                        observer.onError(APIError.decodeError)
                        return
                    }
                    observer.onNext(decoded)
                    observer.onCompleted()
                }else {
                    observer.onError(APIError.invalidResponse)
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
