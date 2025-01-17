//
//  ApplyAPI.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import Foundation
import Moya

enum ApplyAPI {
    case applyWalk(boardId: Int, request: [String: Any])
    case getApplyHistory(tabStatus: Record, walkMatchingStatus: Status)
    case getApplyForm(boardId: Int)
    case getApplyApplicant(boardId: Int)
    case postWalkingApplyForm(boardId: Int, applyId: Int)
    case deleteApplyCancel(applyId: Int)
    case deleteApplyCancelMatching(applyId: Int)
    case getApplyDetail(boardId: Int)
}

extension ApplyAPI: APIEndpoint {
    var path: String {
        switch self {
        case .applyWalk(let boardId, _):
            return "/api/v1/walking/apply/\(boardId)"
        case .getApplyHistory:
            return "/api/v1/walking/apply/history"
        case .getApplyForm(let boardId):
            return "/api/v1/walking/apply/form/\(boardId)"
        case .getApplyApplicant(let boardId):
            return "/api/v1/walking/apply/applicant/\(boardId)"
        case .postWalkingApplyForm(let boardId, _):
            return "/api/v1/walking/apply/form/\(boardId)"
        case .deleteApplyCancel(let applyId):
            return "/api/v1/walking/apply/cancel/\(applyId)"
        case .deleteApplyCancelMatching(let applyId):
            return "/api/v1/walking/apply/cancel/matching/\(applyId)"
        case .getApplyDetail(let boardId):
            return "/api/v1/walking/apply/detail/\(boardId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .applyWalk, .postWalkingApplyForm:
            return .post
        case .getApplyHistory, .getApplyForm, .getApplyApplicant, .getApplyDetail:
            return .get
        case .deleteApplyCancel, .deleteApplyCancelMatching:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .applyWalk(_, let request):
            return .requestParameters(parameters: request, encoding: JSONEncoding.default)
        case .getApplyHistory(tabStatus: let tabStatus, walkMatchingStatus: let walkMatchingStatus):
            return .requestParameters(parameters: ["tabStatus": tabStatus, "walkMatchingStatus": walkMatchingStatus], encoding: URLEncoding.queryString)
        case .getApplyForm, .getApplyApplicant, .deleteApplyCancel, .deleteApplyCancelMatching, .getApplyDetail:
            return .requestPlain
        case .postWalkingApplyForm(_, let applyId):
            return .requestParameters(parameters: ["applyId": applyId], encoding: URLEncoding.queryString)
        }
    }
}
