//
//  ApplyDetailResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/17/25.
//

import Foundation

typealias ApplyDetailResponse = APIResponse<ApplyDetail>

// MARK: - ApplyDetail
struct ApplyDetail: Codable {
    let boardDto: BoardDto
    let applicantDto: ApplicantDto
    let applyDto: ApplyDto
    let ratingDto: RatingDto
    let hashtagDto: [HashtagDto]
}

// MARK: - ApplicantDto
struct ApplicantDto: Codable {
    let applicantName: String
    let applicantProfile: String
    let applicantAge: Int
    let applicantGender, applicantDongAddress, applicantRoadAddress: String
    let applicantRate: Int
}

// MARK: - ApplyDto
struct ApplyDto: Codable {
    let dongAddress, roadAddress, addressDetail, addressMemo: String
    let poopBagYn, muzzleYn, dogCollarYn, preMeetingYn: String
    let memoToOwner: String?
}

// MARK: - BoardDto
struct BoardDto: Codable {
    let dogName: String
    let dogProfile: String
    let dogGender, dongAddress, content, startTime: String
    let endTime: String
}

// MARK: - HashtagDto
struct HashtagDto: Codable {
    let hashtag: String
    let count: Int
}

// MARK: - RatingDto
struct RatingDto: Codable {
    let timePunctuality, communication, attitude, taskCompletion: Double
    let photoSharing: Double
    let participants: Int
}
