//
//  BoardService.swift
//  walkmong
//
//  Created by 신호연 on 1/11/25.
//

import Foundation

struct BoardService {
    private let provider = NetworkProvider<BoardAPI>()
    
    func getBoardList(parameters: [String: String]) async throws -> BoardListResponse {
        do {
            let response = try await provider.request(
                target: .getBoardList(parameters: parameters),
                responseType: BoardListResponse.self
            )
            return response
        } catch {
            throw error
        }
    }
}
