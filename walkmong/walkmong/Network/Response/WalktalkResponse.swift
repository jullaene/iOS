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

typealias GetHistoryResponse = APIResponse<HistoryResponseData>

struct HistoryResponseData: Decodable {
    let data: [HistoryItem]
}

struct HistoryItem: Decodable {
    let message: String
    let senderId: Int
    let createdAt: String
}

typealias GetChatroomResponse = APIResponse<ChatroomResponseData>

struct ChatroomResponseData: Decodable {
    let dogName: String
    let dogProfile: String
    let startTime: String
    let endTime: String
    let chatTarget: Int
    let lastChat: String
    let lastChatTime: String
    let targetName: String
    let notRead: Int
}

