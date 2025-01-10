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
    case clientError(message: String)
    case serverError
    case unauthorized
    case tokenRefreshFailed
    case forbidden
    case unknown
}

struct EmptyDTO: Decodable {}
