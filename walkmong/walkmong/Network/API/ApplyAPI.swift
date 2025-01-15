//
//  ApplyAPI.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import Foundation
import Moya

enum ApplyAPI {
    case applyWalk(boardId: Int, request: [String: Any])
}

extension ApplyAPI: APIEndpoint {
    var path: String {
        switch self {
        case .applyWalk(let boardId, let request): return "/apply"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .applyWalk: return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .applyWalk(let boardId, let request): return .requestParameters(parameters: request, encoding: JSONEncoding.default)
        }
    }
}
