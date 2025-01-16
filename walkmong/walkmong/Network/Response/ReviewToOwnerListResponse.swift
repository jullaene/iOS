//
//  ReviewToOwnerListResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/16/25.
//

import Foundation

typealias ReviewToOwnerListResponse = APIResponse<[ReviewToOwner]>

struct ReviewToOwner: Codable {
    let reviewr: String
    let walkingDay: String
    let sociality: String
    let aggressiveness: String
    let content: String
    let images: [String]
}
