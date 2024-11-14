//
//  BroadAPI.swift
//  walkmong
//
//  Created by 신호연 on 11/14/24.
//

import Foundation
import Moya

enum BoardAPI {
    case getAddressList
}

extension BoardAPI: TargetType {
    var baseURL: URL {
        // Secret.plist에서 BASE_URL 가져오기
        guard let baseUrl = SecretManager.shared.getValue(forKey: "BASE_URL") else {
            fatalError("BASE_URL이 설정되지 않았습니다!")
        }
        return URL(string: baseUrl)!
    }
    
    var path: String {
        switch self {
        case .getAddressList:
            return "/api/v1/board/address/list"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String: String]? {
        // Secret.plist에서 API_TOKEN 가져오기
        guard let token = SecretManager.shared.getValue(forKey: "API_TOKEN") else {
            print("API_TOKEN을 찾을 수 없습니다!")
            return nil
        }
        return [
            "Authorization": "Bearer \(token)"
        ]
    }
}
