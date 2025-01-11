//
//  MatchingStatusListResponse.swift
//  walkmong
//
//  Created by 황채웅 on 1/11/25.
//

import Foundation

typealias MatchingStatusListResponse = APIResponse<[MatchingStatusListResponseData]>

struct MatchingStatusListResponseData: Decodable {
    let dogName: String
    let dogGender: String
    let dogProfile: String
    let dongAddress: String
    let addressDetail: String
    let startTime: String
    let endTime: String
    let distance: Double
    let walkerNickname: String?
    let walkerProfile: String?
}
