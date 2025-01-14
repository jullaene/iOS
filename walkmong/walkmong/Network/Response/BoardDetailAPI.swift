//
//  BoardDetailAPI.swift
//  walkmong
//
//  Created by 신호연 on 1/14/25.
//

import Foundation

typealias BoardDetailDetailResponse = APIResponse<[BoardDetail]>

struct BoardDetail: Decodable {
    let dogId: Int
    let dogName: String
    let dogProfile: String?
    let dogGender: String
    let dogAge: Int
    let breed: String
    let weight: Double
    let dogSize: String
    let dongAddress: String
    let distance: Double
    let date: String?
    let startTime: String
    let endTime: String
    let locationNegotiationYn: String
    let suppliesProvidedYn: String
    let preMeetAvailableYn: String
    let walkNote: String
    let walkRequest: String
    let additionalRequest: String
    let ownerName: String
    let ownerAge: Int
    let ownerGender: String
    let ownerProfile: String?
    let ownerRate: Double?
}
