//
//  WalktalkResponse.swift
//  walkmong
//
//  Created by 황채웅 on 1/3/25.
//

import Foundation

typealias CreateChatroomResponse = APIResponse<CreateChatroomResponseData>

struct CreateChatroomResponseData: Decodable {
    var roomId: Int
}

typealias GetHistoryResponse = APIResponse<[HistoryItem]>

struct HistoryItem: Decodable {
    let message: String
    let senderId: Int
    let createdAt: String
}

typealias GetChatroomResponse = APIResponse<[ChatroomResponseData]>

struct ChatroomResponseData: Decodable {
    var dogName: String
    var dogProfile: String
    var startTime: String
    var endTime: String
    var chatTarget: Int
    var lastChat: String
    var lastChatTime: String
    var targetName: String
    var notRead: Int
    var roomId: Int
}

