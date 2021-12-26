//
//  ServiceError.swift
//  GithubRepo
//
//  Created by admin on 15/11/2021.
//

import Foundation

public enum APIError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
    case somethingWrong
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .apiError:
            return NSLocalizedString("error from api", comment: "api")
        case .invalidEndpoint:
            return NSLocalizedString("Endpoint is invalid", comment: "endpoint")
        case .invalidResponse:
            return NSLocalizedString("Response is invalid", comment: "response")
        case .noData:
            return NSLocalizedString("there is no data", comment: "nodata")
        case .decodeError:
            return NSLocalizedString("error in decoding", comment: "decode")
        case .somethingWrong:
            return NSLocalizedString("something went wrong", comment: "something wrong")
        }
    }
}
