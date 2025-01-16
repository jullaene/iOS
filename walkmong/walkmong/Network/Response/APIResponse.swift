//
//  APIResponse.swift
//  walkmong
//
//  Created by 신호연 on 11/15/24.
//

import Foundation

struct APIResponse<DTO: Decodable>: Decodable {
    let message: String
    let statusCode: Int
    let data: DTO
}

enum NetworkError: Error {
    case errorWithMessage(message: String)
    case serverError
    case unauthorized
    case tokenRefreshFailed
    case forbidden
    case unknown
    
    var message: String {
        switch self {
        case .unauthorized:
            return "Unauthorized access. Please log in again."
        case .forbidden:
            return "You do not have permission to perform this action."
        case .errorWithMessage(let message):
            return (message)
        case .serverError:
            return "Server error. Please try again later."
        case .tokenRefreshFailed:
            return "Failed to refresh the token. Please log in again."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

struct EmptyDTO: Decodable {}
