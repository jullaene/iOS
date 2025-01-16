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
    
    func getReviewToOwnerList() async throws -> ReviewToOwnerListResponse {
        return try await provider.request(
            target: .reviewToOwnerList,
            responseType: ReviewToOwnerListResponse.self
        )
    }
    
    func reviewToWalkerRegister(requestBody: ReviewToWalkerRegister) async throws -> ReviewToWalkerRegisterResponse {
        return try await provider.request(
            target: .registerReview(requestBody: requestBody.toDictionary()),
            responseType: ReviewToWalkerRegisterResponse.self
        )
    }
}

private extension ReviewToWalkerRegister {
    func toDictionary() -> [String: Any] {
        return [
            "walkerId": walkerId as Any,
            "boardId": boardId,
            "timePunctuality": timePunctuality,
            "communication": communication,
            "attitude": attitude,
            "taskCompletion": taskCompletion,
            "photoSharing": photoSharing,
            "hashtags": hashtags ?? NSNull(),
            "images": images ?? NSNull(),
            "content": content ?? NSNull()
        ]
    }
}
