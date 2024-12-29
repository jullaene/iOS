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

extension DogAPI: APIEndpoint {
    
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
}
