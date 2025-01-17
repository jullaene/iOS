//
//  GetApplyHistoryResponse.swift
//  walkmong
//
//  Created by 황채웅 on 1/15/25.
//

import Foundation

typealias GetApplyHistoryResponse = APIResponse<[ApplyHistoryItem]>

struct ApplyHistoryItem: Decodable {
    let tabStatus: String
    let dogName: String
    let dogGender: String
    let dogProfile: String
    let startTime: String
    let endTime: String
    let dongAddress: String?
    let distance: Double?
    let walkerName: String?
    let walkerProfile: String?
    let walkMatchingStatus: String
    let content: String
    let boardId: Int
    let applyId: Int
}
