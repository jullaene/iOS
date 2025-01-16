//
//  ReviewAPI.swift
//  walkmong
//
//  Created by 신호연 on 12/29/24.
//

import Foundation
import Moya

enum ReviewAPI {
    case registerReview(requestBody: [String: Any])
    case reviewToWalkerList
    case reviewToWalkerRegister(walkerId: Int, boardId: Int)
}

extension ReviewAPI: APIEndpoint {
    
    var path: String {
        switch self {
        case .registerReview:
            return "/api/v1/review/to/walker/register"
        case .reviewToWalkerList:
            return "/api/v1/review/to/walker/list"
        case .reviewToWalkerRegister:
            return "/api/v1/review/to/walker/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerReview, .reviewToWalkerRegister:
            return .post
        case .reviewToWalkerList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .registerReview(let requestBody):
            return .requestParameters(parameters: requestBody, encoding: JSONEncoding.default)
        case .reviewToWalkerList:
            return .requestPlain
        case .reviewToWalkerRegister(let walkerId, let boardId):
            return .requestParameters(parameters: ["walkerId": walkerId, "boardId": boardId], encoding: URLEncoding.queryString)
        }
    }
}
