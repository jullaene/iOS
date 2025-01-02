//
//  WalktalkAPI.swift
//  walkmong
//
//  Created by 황채웅 on 1/3/25.
//

import Foundation
import Moya

enum WalktalkAPI {
    case createChatroom(boardId: Int)
    case getHistory(roomId: Int)
    case getChatroom
}

extension WalktalkAPI: APIEndpoint {
    
    var path: String {
        switch self {
        case .createChatroom(boardId: let boardId):
            return "/chatroom/\(boardId)"
        case .getHistory(roomId: let roomId):
            return "/chatroom/history/\(roomId)"
        case .getChatroom:
            return "/chatroom/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createChatroom:
            return .post
        case .getHistory, .getChatroom:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .createChatroom, .getHistory, .getChatroom:
            return .requestPlain
        }
    }
}
