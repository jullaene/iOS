//
//  ReviewService.swift
//  walkmong
//
//  Created by 신호연 on 1/15/25.
//

import Foundation

struct ReviewService {
    private let provider = NetworkProvider<ReviewAPI>()
    
    func getReviewToWalkerList() async throws -> ReviewToWalkerListResponse {
        return try await provider.request(
            target: .reviewToWalkerList,
            responseType: ReviewToWalkerListResponse.self
        )
    }
}
