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
    case getBoardDetail(boardId: Int)
    case saveCurrentLocation(boardId: Int, latitude: Double, longitude: Double)
    case getCurrentLocation(boardId: Int)
    case changeStatus(status: String, boardId: Int)
}

extension BoardAPI: APIEndpoint {
    var method: Moya.Method {
        switch self {
        case .getBoardList, .getAddressList, .getBoardDetail, .getCurrentLocation:
            return .get
        case .registerBoard, .saveCurrentLocation:
            return .post
        case .changeStatus:
            return .patch
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
        case .getBoardDetail(let boardId):
            print("Request URL: /api/v1/board/detail/\(boardId)")
            return "/api/v1/board/detail/\(boardId)"
        case .saveCurrentLocation(let boardId, _, _), .getCurrentLocation(let boardId):
            return "/api/v1/board/geo/\(boardId)"
        case .changeStatus(_, let boardId):
            return "/api/v1/board/walk/status/\(boardId)"
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getBoardList(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getAddressList,  .getBoardDetail, .getCurrentLocation:
            return .requestPlain
        case .registerBoard(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .saveCurrentLocation(_, latitude: let latitude, longitude: let longitude):
            return .requestParameters(parameters: ["latitude": latitude, "longitude": longitude], encoding: JSONEncoding.default)
        case .changeStatus(status: let status, _):
            return .requestParameters(parameters: ["status": status], encoding: URLEncoding.queryString)
        }
    }
}
