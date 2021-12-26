//
//  RequestableAPIProtocol.swift
//  GithubRepo
//
//  Created by admin on 15/11/2021.
//

import Foundation

enum HttpMethod: String, CustomStringConvertible {
    case get
    case post
    
    var description: String {
        return rawValue.uppercased()
    }
}

protocol RequestableAPI{
    var baseURLString: String { get }
    var path: String? { get }
    var httpMethod: HttpMethod { get }
    var params: [String: Any]? { get }
    var urlRequest: URLRequest? { get }
}
