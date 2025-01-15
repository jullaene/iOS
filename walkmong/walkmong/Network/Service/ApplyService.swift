//
//  ApplyService.swift
//  walkmong
//
//  Created by 황채웅 on 1/15/25.
//

import Foundation

struct ApplyService {
    private let provider = NetworkProvider<ApplyAPI>()
    
    func applyWalk(boardId: Int, request: WalkRequestData) async throws -> APIResponse<String> {
        let request = ["dongAddress":request.dongAddress, "roadAddress": request.roadAddress, "latitude": request.latitude, "longitude": request.longitude, "addressDetail": request.addressDetail, "addressMemo": request.addressMemo, "poopBagYn": request.poopBagYn, "muzzleYn": request.muzzleYn, "dogCollarYn": request.dogCollarYn, "preMeetingYn": request.preMeetingYn, "memoToOwner": request.memoToOwner]
        return try await provider.request(
            target: .applyWalk(boardId: boardId, request: request),
            responseType: APIResponse<String>.self
        )
    }
    
    func getApplyHistory(tabStatus: Record, walkMatchingStatus: Status) async throws -> GetApplyHistoryResponse {
        return try await provider.request(
            target: .getApplyHistory(tabStatus: tabStatus, walkMatchingStatus: walkMatchingStatus),
            responseType: GetApplyHistoryResponse.self
        )
    }
    
}
