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
    case getApplyApplicant(boardId: Int, applyId: Int)
    case postApplyForm(boardId: Int)
    case getApplyMyForm(applyId: Int)
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
        case .getApplyApplicant(let boardId, _):
            return "/api/v1/walking/apply/applicant/\(boardId)"
        case .postApplyForm(let boardId):
            return "/api/v1/walking/apply/form/\(boardId)"
        case .getApplyMyForm(let applyId):
            return "/api/v1/walking/apply/myForm/\(applyId)"
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
        case .applyWalk, .postApplyForm:
            return .post
        case .getApplyHistory, .getApplyForm, .getApplyApplicant, .getApplyMyForm, .getApplyDetail:
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
        case .getApplyForm, .postApplyForm, .getApplyMyForm, .deleteApplyCancel, .deleteApplyCancelMatching, .getApplyDetail:
            return .requestPlain
        case .getApplyApplicant(_, let applyId):
            return .requestParameters(parameters: ["applyId": applyId], encoding: JSONEncoding.default)
            // 리퀘스트 바디 라고 적힌 게 있는 경우 -> .requestParameters()
            // 리퀘스트 바디 도 없고 쿼리 파라미터도 없는 경우 -> .requestPlain
            // 리퀘스트 바디가 폼 데이터인 경우( 이건 var headers?도 따로 설정해줘야함. 이따 나한ㅌ ㅔ말해)
        }
    }
}

