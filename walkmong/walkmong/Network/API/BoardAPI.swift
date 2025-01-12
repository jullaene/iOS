//
//  BoardAPI.swift
//  walkmong
//
//  Created by 신호연 on 1/11/25.
//

import Foundation
import Moya

enum BoardAPI {
    case getBoardList
}

extension BoardAPI: APIEndpoint {
    var method: Moya.Method {
        switch self {
        case .getBoardList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getBoardList:
            return "/api/v1/board/list"
        }
    }
    
    var task: Task {
        switch self {
        case .getBoardList:
            return .requestPlain
        }
    }
}
