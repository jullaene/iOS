//
//  ApplyApplicantResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/17/25.
//

import Foundation

typealias ApplyApplicantResponse = APIResponse<ApplyApplicant>

struct ApplyApplicant: Codable {
    let applicantDto: [ApplicantDto]
    let boardDto: ApplicantBoardDto
}

struct ApplicantDto: Codable {
    let applicantName: String
    let applicantProfile: String
    let applicantAge: Int
    let applicantGender: String
    let dongAddress: String
    let roadAddress: String
    let applicantRate: Int
}

struct ApplicantBoardDto: Codable {
    let dogName: String
    let dogProfile: String
    let dogGender: String
    let dongAddress: String?
    let content: String
    let startTime: String
    let endTime: String
}
