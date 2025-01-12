//
//  BoardService.swift
//  walkmong
//
//  Created by 신호연 on 1/11/25.
//

import Foundation

struct BoardService {
    private let provider = NetworkProvider<BoardAPI>()
    
    func getBoardList() async throws -> BoardListResponse {
        do {
            let response = try await provider.request(
                target: .getBoardList,
                responseType: BoardListResponse.self
            )
            print("Decoded Response: \(response)") // 디코딩된 응답
            print("Response Data Count: \(response.data.count)") // 데이터 개수 확인
            return response
        } catch {
            print("Error: \(error.localizedDescription)")
            throw error
        }
    }
}
