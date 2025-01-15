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
    case getApplyHistory(tabStatus: Record, walkMatchingStatus: Status)
}

extension ApplyAPI: APIEndpoint {
    var path: String {
        switch self {
        case .applyWalk(let boardId, _): return "/api/v1/walking/apply/\(boardId)"
        case .getApplyHistory:
            return "/api/v1/walking/apply/history"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .applyWalk: return .post
        case .getApplyHistory:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .applyWalk(_, let request): return .requestParameters(parameters: request, encoding: JSONEncoding.default)
        case .getApplyHistory(tabStatus: let tabStatus, walkMatchingStatus: let walkMatchingStatus):
            return .requestParameters(parameters: ["tabStatus": tabStatus, "walkMatchingStatus": walkMatchingStatus], encoding: URLEncoding.queryString)
        }
    }
}
