//
//  DogAPI.swift
//  walkmong
//
//  Created by 신호연 on 11/15/24.
//

import Foundation
import Moya

enum DogAPI {
    case getDogProfile(dogId: Int)
    case getDogList
}

extension DogAPI: TargetType {
    var baseURL: URL {
        guard let url = SecretManager.shared.getValue(forKey: "BASE_URL") else {
            fatalError("BASE_URL이 설정되지 않았습니다!")
        }
        return URL(string: url)!
    }
    
    var path: String {
        switch self {
        case .getDogProfile(let dogId):
            return "/api/v1/dog/profile/\(dogId)"
        case .getDogList:
            return "/api/v1/dog/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDogProfile, .getDogList:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getDogProfile, .getDogList:
            return .requestPlain
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
}
