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
    let dogID: Int
    let dogName, dogGender, content, ownerDongAddress: String
    let walkerID: Int
    let walkerNickname, walkerGender: String
    let walkerAge: Int
    let walkRequest, walkNote, additionalRequest: String
    let latitude, longitude: Double
    let roadAddress, addressDetail, addressMemo: String
    let memoToOwner: String?

    enum CodingKeys: String, CodingKey {
        case date, startTime, endTime
        case dogID = "dogId"
        case dogName, dogGender, content, ownerDongAddress
        case walkerID = "walkerId"
        case walkerNickname, walkerGender, walkerAge, walkRequest, walkNote, additionalRequest, latitude, longitude, roadAddress, addressDetail, addressMemo, memoToOwner
    }
}
