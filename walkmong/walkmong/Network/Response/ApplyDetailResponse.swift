//
//  ApplyDetailResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/17/25.
//

import Foundation

typealias ApplyDetailResponse = APIResponse<ApplyDetail>

struct ApplyDetail: Codable {
    let date, startTime, endTime: String
    let dogId: Int
    let dogName, dogGender, content, ownerDongAddress: String
    let walkerId: Int
    let walkerNickname, walkerGender: String
    let walkerAge: Int
    let walkRequest, walkNote, additionalRequest: String
    let latitude, longitude: Double
    let roadAddress, addressDetail, addressMemo: String
    let memoToOwner: String?
}
