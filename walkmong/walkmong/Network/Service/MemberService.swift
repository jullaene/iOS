//
//  MemberService.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import Foundation
import Moya

struct MemberService {
    private let provider: NetworkProvider<MemberAPI>
    
    func postAddress(request: PostAddressRequest) async throws -> APIResponse<String> {
        return try await provider.request(
            target: .postAddress(request: request),
            responseType: APIResponse<String>.self
        )
    }
    
}
