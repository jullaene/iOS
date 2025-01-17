//
//  ApplyApplicantResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/17/25.
//

import Foundation

typealias ApplyApplicantResponse = APIResponse<ApplyApplicant>

struct ApplyApplicant: Codable {
    let dogName: String
    let dogProfile: String
    let dogGender, dongAddress, content, startTime: String
    let endTime: String
}
