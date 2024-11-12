//
//  DogInformation.swift
//  walkmong
//
//  Created by 신호연 on 11/10/24.
//

import Foundation

struct DogInformation: Codable {
    // 반려견 정보
    let dogId: String
    let dogName: String
    let profile: String
    let dogGender: String
    let dogAge: Int
    let breed: String
    let weight: String
    let dogSize: String
    let dongAddress: String
    let distance: String

    // 산책 일정 및 요청
    let date: String
    let startTime: String
    let endTime: String
    let locationNegotiableYn: Bool
    let suppliesProvidedYn: Bool
    let preMeetAvailableYn: Bool
    let walkNote: String
    let walkRequest: String
    let additionalRequest: String

    // 반려인 정보
    let ownerName: String
    let ownerAge: Int
    let ownerGender: String
    let ownerRate: Double
}
