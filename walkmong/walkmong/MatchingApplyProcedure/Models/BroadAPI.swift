// BoardAPI.swift
import Foundation
import Moya

enum BoardAPI {
    case getAddressList
    case getBoardList(date: String?, addressId: Int?, distance: String?, dogSize: String?, matchingYn: String?)
    case getBoardDetail(boardId: Int)
}

extension BoardAPI: TargetType {
    var baseURL: URL {
        guard let url = SecretManager.shared.getValue(forKey: "BASE_URL") else {
            fatalError("BASE_URL이 설정되지 않았습니다!")
        }
        return URL(string: url)!
    }
    
    var path: String {
        switch self {
        case .getAddressList:
            return "/api/v1/address/list"
        case .getBoardList:
            return "/api/v1/board/list"
        case .getBoardDetail(let boardId):
            return "/api/v1/board/detail/\(boardId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAddressList, .getBoardList, .getBoardDetail:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getAddressList, .getBoardDetail:
            return .requestPlain
        case let .getBoardList(date, addressId, distance, dogSize, matchingYn):
            var params: [String: Any] = [:]
            if let date = date { params["date"] = date }
            if let addressId = addressId { params["addressId"] = addressId }
            if let distance = distance { params["distance"] = distance }
            if let dogSize = dogSize { params["dogSize"] = dogSize }
            if let matchingYn = matchingYn { params["matchingYn"] = validYn(matchingYn) }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        guard let token = SecretManager.shared.getValue(forKey: "API_TOKEN") else {
            return nil
        }
        return [
            "Authorization": "Bearer \(token)"
        ]
    }

    // Yn 값 검증 함수
    private func validYn(_ value: String) -> String {
        return (value == "Y" || value == "N") ? value : "N" // 기본값은 N으로 설정
    }
}
