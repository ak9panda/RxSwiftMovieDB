//
//  MovieAPl.swift
//  GithubRepo
//
//  Created by admin on 15/11/2021.
//

import Foundation

struct Routes {
    static let ROUTE_TOP_RATED_MOVIES = "/movie/top_rated"
    static let ROUTE_POPULAR_MOVIES = "/movie/popular"
    static let ROUTE_UPCOMING_MOVIES = "/movie/upcoming"
    static let ROUTE_NOW_PLAYING_MOVIES = "/movie/now_playing"
    static let ROUTE_GENRE_LIST = "genre/movie/list"
}

enum MovieAPI {
    case topRateMoves
    case popularMovies
    case upcomingMovies
    case nowplayingMovies
    case movie(id: String)
    case genres
    case backdropImage(path: String)
    case posterImage(path: String)
}

extension MovieAPI: RequestableAPI {
    var baseURLString: String {
        switch self {
        case .backdropImage, .posterImage:
            return AppConstraints.BASE_IMG_URL
        default:
            return AppConstraints.BASE_URL
        }
    }
    
    var path: String? {
        switch self {
        case .popularMovies: return Routes.ROUTE_POPULAR_MOVIES
        case .topRateMoves: return Routes.ROUTE_TOP_RATED_MOVIES
        case .upcomingMovies: return Routes.ROUTE_UPCOMING_MOVIES
        case .nowplayingMovies: return Routes.ROUTE_NOW_PLAYING_MOVIES
        case .movie(let id):
            guard !id.isEmpty else { return nil }
            return "movie/\(id)"
        case .genres: return Routes.ROUTE_GENRE_LIST
        case .backdropImage(let path):
            guard !path.isEmpty else { return nil }
            return path
        case .posterImage(let path):
            guard !path.isEmpty else { return nil }
            return path
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .popularMovies, .topRateMoves, .upcomingMovies, .nowplayingMovies:
            return .get
        default:
            return .get
        }
    }
    
    var params: [String : Any]? {
        var defaultParam: [String: Any] {
          return ["api_key": Settings.apiKey]
        }
        
        switch self {
        case .popularMovies, .topRateMoves, .upcomingMovies, .nowplayingMovies:
            let params = defaultParam
            return params
        default:
            return defaultParam
        }
    }
    
    var urlRequest: URLRequest? {
        guard let path = path else { return nil }
        
        let basePath: String
        if let params = params {
            basePath = path + params.formatToUrlParams()
        }else {
            basePath = path
        }
        
        guard let url = URL(string: baseURLString + basePath) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.description
        
        return urlRequest
    }
}
