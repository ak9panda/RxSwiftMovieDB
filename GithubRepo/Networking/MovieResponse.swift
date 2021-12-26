//
//  MovieResponse.swift
//  GithubRepo
//
//  Created by admin on 22/10/2021.
//

import Foundation
import RxDataSources

enum MovieTag : String {
    case NOW_PLAYING = "Now Playing"
    case POPULAR = "Popular"
    case TOP_RATED = "Top Rated"
    case UPCOMING = "Upcoming"
    case NOT_LISTED = "Not Listed"
}

// MARK: - MovieListResponse
struct MovieListResponse : Codable {
    let page : Int
    let total_results : Int
    let total_pages : Int
    let results : [MovieInfoResponse]
}

// MARK: - Result
struct MovieInfoResponse : Codable {
    
    let popularity : Double?
    let vote_count : Int?
    let video : Bool?
    let poster_path : String?
    let id : Int?
    let adult : Bool?
    let backdrop_path : String?
    let original_language : String?
    let original_title : String?
    let genre_ids: [Int]?
    let title : String?
    let vote_average : Double?
    let overview : String?
    let release_date : String?
    let budget : Int?
    let homepage : String?
    let imdb_id : String?
    let revenue : Int?
    let runtime : Int?
    let tagline : String?
    var movieTag : MovieTag? = MovieTag.NOT_LISTED
    
    enum CodingKeys:String,CodingKey {
        case popularity
        case vote_count
        case video
        case poster_path
        case id
        case adult
        case backdrop_path
        case original_language
        case original_title
        case genre_ids
        case title
        case vote_average
        case overview
        case release_date
        case budget
        case homepage
        case imdb_id
        case revenue
        case runtime
        case tagline
    }
}


struct MoviesSection {
    var header: String
    var movies: [MovieInfoResponse]
}

extension MoviesSection: AnimatableSectionModelType {
    typealias Item = MovieInfoResponse
    typealias Identity = String

    var identity: String {
        return header
    }

    var items: [MovieInfoResponse] {
        set {
            movies = newValue
        }
        get {
            return movies
        }
    }

    init(original: MoviesSection, items: [MovieInfoResponse]) {
        self = original
        self.movies = items
    }
}

extension MovieInfoResponse: IdentifiableType, Equatable {
    
    public typealias Identity = String

    public var identity: String {
        return title!
    }
    
    static func == (lhs: MovieInfoResponse, rhs: MovieInfoResponse) -> Bool {
        return lhs.vote_count ?? 0 > rhs.vote_count ?? 0
    }
}
