//
//  ApplyFormResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/17/25.
//

import Foundation

typealias ApplyFormResponse = APIResponse<ApplyForm>

// MARK: - DataClass
struct ApplyForm: Codable {
    let boardDto: BoardDto
    let applicantDto: FormApplicantDto
    let applyDto: ApplyDto
    let ratingDto: RatingDto
    let hashtagDto: [HashtagDto]
}

// MARK: - ApplicantDto
struct FormApplicantDto: Codable {
    let applicantName: String
    let applicantProfile, applicantAge, applicantGender: String?
    let applicantDongAddress, applicantRoadAddress: String
    let applicantRate: Int
}

// MARK: - ApplyDto
struct ApplyDto: Codable {
    let dongAddress, roadAddress, addressDetail, addressMemo: String
    let poopBagYn, muzzleYn, dogCollarYn, preMeetingYn: String
    let memoToOwner: String
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
    let timePunctuality, communication, attitude, taskCompletion: Int
    let photoSharing, participants: Int
}
