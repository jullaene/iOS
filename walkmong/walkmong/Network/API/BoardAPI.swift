//
//  BoardAPI.swift
//  walkmong
//
//  Created by 신호연 on 1/11/25.
//

import Foundation
import Moya

enum BoardAPI {
    case getBoardList(parameters: [String: String])
    case getAddressList
    case registerBoard(parameters: [String: Any])
}

extension BoardAPI: APIEndpoint {
    var method: Moya.Method {
        switch self {
        case .getBoardList, .getAddressList:
            return .get
        case .registerBoard:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getBoardList:
            return "/api/v1/board/list"
        case .getAddressList:
            return "/api/v1/address/list"
        case .registerBoard:
            return "/api/v1/board/register"
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getBoardList(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getAddressList:
            return .requestPlain
        case .registerBoard(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
