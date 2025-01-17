//
//  ApplyFormResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/17/25.
//

import Foundation

typealias ApplyFormResponse = APIResponse<ApplyForm>

// MARK: - Welcome
struct ApplyForm: Codable {
    let previewResponseDto: PreviewResponseDto
    let applyInfoResponseDto: ApplyInfoResponseDto
}

// MARK: - ApplyInfoResponseDto
struct ApplyInfoResponseDto: Codable {
    let dongAddress, roadAddress, addressDetail, addressMemo: String
    let poopBagYn, muzzleYn, dogCollarYn, preMeetingYn: String
    let memoToOwner: String?
}

// MARK: - PreviewResponseDto
struct PreviewResponseDto: Codable {
    let dogName: String
    let dogProfile: String
    let dogGender, dongAddress, content, startTime: String
    let endTime: String
}
