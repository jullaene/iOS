//
//  ReviewAPI.swift
//  walkmong
//
//  Created by 신호연 on 12/29/24.
//

import Foundation
import Moya

enum ReviewAPI: APIEndpoint {
    case registerReview(requestBody: [String: Any])

    var path: String {
        switch self {
        case .registerReview:
            return "/api/v1/review/to/walker/register"
        }
    }

    var method: Moya.Method {
        switch self {
        case .registerReview:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .registerReview(let requestBody):
            return .requestParameters(parameters: requestBody, encoding: JSONEncoding.default)
        }
    }
}
