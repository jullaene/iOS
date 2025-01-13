//
//  BoardRegisterResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/14/25.
//

import Foundation

typealias BoardRegisterResponse = APIResponse<BoardRegisterData>

struct BoardRegisterData: Codable {
    let boardId: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.boardId = try container.decode(Int.self)
    }
}

struct MatchingApplyWalkRequestData {
    let dogId: Int
    let addressId: Int
    let startTime: String
    let endTime: String
    let locationNegotiationYn: String
    let preMeetAvailableYn: String
    let walkRequest: String
    let walkNote: String
    let additionalRequest: String
}
