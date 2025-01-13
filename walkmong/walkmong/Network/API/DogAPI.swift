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
    case registerDogProfile(dogProfile: PostDogInfoRequest)
}

extension DogAPI: APIEndpoint {
    
    var path: String {
        switch self {
        case .getDogProfile(let dogId):
            return "/api/v1/dog/profile/\(dogId)"
        case .getDogList:
            return "/api/v1/dog/list"
        case .registerDogProfile:
            return "/api/v1/dog/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDogProfile, .getDogList:
            return .get
        case .registerDogProfile:
            return .post
        }
    }
    
    var headers: [String: String]? {
        guard let token = SecretManager.shared.TEST_TOKEN else {
            /// Access Token이 없는 경우
            return ["Content-Type": "application/json"]
        }
        switch self {
        case .registerDogProfile:
            return [
                "Content-Type": "multipart/form-data",
                "Authorization": "Bearer \(token)"
            ]
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]

        }
    }
    var task: Task {
        switch self {
        case .getDogProfile, .getDogList:
            return .requestPlain
        case .registerDogProfile(let dogInfoRequest):
            return .uploadMultipart(dogInfoRequest.toMultipartData())
        }
    }
}
