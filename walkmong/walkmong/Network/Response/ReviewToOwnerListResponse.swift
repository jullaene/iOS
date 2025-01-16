//
//  ReviewToOwnerListResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/16/25.
//

import Foundation

typealias ReviewToOwnerListResponse = APIResponse<[ReviewToOwner]>

struct ReviewToOwner: Codable {
    let reviewer: String
    let reviewerProfile: String
    let walkingDay: String
    let sociality: String
    let activity: String
    let aggressiveness: String
    let content: String
    let images: [String]
}
