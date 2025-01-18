//
//  ApplyService.swift
//  walkmong
//
//  Created by 황채웅 on 1/15/25.
//

import Foundation

struct ApplyService {
    private let provider = NetworkProvider<ApplyAPI>()
    
    func applyWalk(boardId: Int, request: WalkRequestData) async throws -> APIResponse<Int> {
        let request = ["dongAddress":request.dongAddress, "roadAddress": request.roadAddress, "latitude": request.latitude, "longitude": request.longitude, "addressDetail": request.addressDetail, "addressMemo": request.addressMemo, "poopBagYn": request.poopBagYn, "muzzleYn": request.muzzleYn, "dogCollarYn": request.dogCollarYn, "preMeetingYn": request.preMeetingYn, "memoToOwner": request.memoToOwner]
        return try await provider.request(
            target: .applyWalk(boardId: boardId, request: request),
            responseType: APIResponse<Int>.self
        )
    }
    
    func getApplyHistory(tabStatus: Record, walkMatchingStatus: Status) async throws -> GetApplyHistoryResponse {
        return try await provider.request(
            target: .getApplyHistory(tabStatus: tabStatus, walkMatchingStatus: walkMatchingStatus),
            responseType: GetApplyHistoryResponse.self
        )
    }
    
    func getApplyForm(boardId: Int) async throws -> ApplyFormResponse {
        return try await provider.request(target: .getApplyForm(boardId: boardId), responseType: ApplyFormResponse.self)
    }
    
    func getApplyApplicant(boardId: Int, applyId: Int) async throws -> ApplyApplicantResponse {
        return try await provider.request(target: .getApplyApplicant(boardId: boardId, applyId: applyId), responseType: ApplyApplicantResponse.self)
    }
    
    func postApplyForm(boardId: Int, applyId: Int) async throws -> EmptyResponse {
        return try await provider.request(target: .getApplyApplicant(boardId: boardId, applyId: applyId), responseType: EmptyResponse.self)
    }
    
    func getApplyMyForm(applyId: Int) async throws -> ApplyApplicantResponse {
        return try await provider.request(target: .getApplyMyForm(applyId: applyId), responseType: ApplyApplicantResponse.self)
    }
    
    func deleteApplyCancel(applyId: Int) async throws -> APIResponse<String> {
        return try await provider.request(target: .deleteApplyCancel(applyId: applyId), responseType: APIResponse<String>.self)
    }
    
    func deleteApplyCancelMatching(applyId: Int) async throws -> EmptyResponse {
        return try await provider.request(target: .deleteApplyCancelMatching(applyId: applyId), responseType: EmptyResponse.self)
    }
    
    func getApplyDetail(boardId: Int) async throws -> ApplyDetailResponse {
        return try await provider.request(target: .getApplyDetail(boardId: boardId), responseType: ApplyDetailResponse.self)
    }
    
}
