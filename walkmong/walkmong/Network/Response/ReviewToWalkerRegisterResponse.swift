//
//  ReviewToWalkerRegisterResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/16/25.
//

import Foundation

typealias ReviewToWalkerRegisterResponse = APIResponse<ReviewToWalkerRegister>

struct ReviewToWalkerRegister: Codable {
    let walkerId: Int?
    let boardId: Int
    let timePunctuality: Float
    let communication: Float
    let attitude: Float
    let taskCompletion: Float
    let photoSharing: Float
    let hashtags: [String]?
    let images: [String]?
    let content: String?
}
