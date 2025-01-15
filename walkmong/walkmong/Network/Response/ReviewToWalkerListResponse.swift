//
//  ReviewToWalkerListResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/15/25.
//

import Foundation

typealias ReviewToWalkerListResponse = APIResponse<[ReviewToWalker]>

struct ReviewToWalker: Codable {
    let reviewToWalkerId: Int
    let ownerName: String
    let dogName: String
    let walkingDay: String
    let photoSharing: Float
    let attitude: Float
    let taskCompletion: Float
    let timePunctuality: Float
    let communication: Float
    let profiles: [String]?
    let content: String
    let hashtags: [String]
}
