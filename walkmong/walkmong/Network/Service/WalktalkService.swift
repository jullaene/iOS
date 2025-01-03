//
//  WalktalkService.swift
//  walkmong
//
//  Created by 황채웅 on 1/3/25.
//

import Foundation

struct WalktalkService {
    private let provider = NetworkProvider<WalktalkAPI>()
    
    func createChatroom(boardId: Int) async throws -> CreateChatroomResponse {
        return try await provider.request(
            target: .createChatroom(boardId: boardId),
            responseType: CreateChatroomResponse.self
        )
    }
    
    func getHistory(roomId: Int) async throws -> GetHistoryResponse {
        return try await provider.request(
            target: .getHistory(roomId: roomId),
            responseType: GetHistoryResponse.self
        )
    }
    
    func getChatroom(record: Record, status: Status) async throws -> GetChatroomResponse {
        return try await provider.request(
            target: .getChatroom(record: record, status: status),
            responseType: GetChatroomResponse.self
        )
    }
    
}
