//
//  MemberService.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import Foundation
import Moya

struct MemberService {
    private let provider = NetworkProvider<MemberAPI>()
    
    func postAddress(request: PostAddressRequest) async throws -> APIResponse<Int> {
        return try await provider.request(
            target: .postAddress(request: request),
            responseType: APIResponse<Int>.self
        )
    }
    
    func getMemberWalking() async throws -> APIResponse<MemberWalkingItem> {
        return try await provider.request(
            target: .getMemberWalking,
            responseType: APIResponse<MemberWalkingItem>.self
        )
    }
    
    func postDogExperience(request: PostDogExperienceRequest) async throws -> APIResponse<Int> {
        return try await provider.request(
            target: .postDogExperience(request: request),
            responseType: APIResponse<Int>.self
        )
    }
    
}
