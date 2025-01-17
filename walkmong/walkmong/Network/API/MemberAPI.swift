//
//  MemberAPI.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import Foundation
import Moya

enum MemberAPI {
    case postAddress(request: PostAddressRequest)
    case getMemberWalking
    case postDogExperience(request: PostDogExperienceRequest)
}

extension MemberAPI: APIEndpoint {
    var path: String {
        switch self {
        case .postAddress: return "/api/v1/address"
        case .getMemberWalking: return "/api/v1/member/walking"
        case .postDogExperience: return "/api/v1/member/experience"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postAddress, .postDogExperience: return .post
        case .getMemberWalking: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postAddress(let request):
            return .requestParameters(parameters: ["dongAddress": request.dongAddress, "roadAddress": request.roadAddress, "latitude": request.latitude, "longitude": request.longitude, "distanceRange": request.distanceRange, "basicAddressYn": request.basicAddressYn], encoding: JSONEncoding.default)
        case .getMemberWalking:
            return .requestPlain
        case .postDogExperience(request: let request):
            return .requestParameters(parameters: ["dogOwnershipYn":request.dogOwnershipYn, "dogWalkingExperienceYn":request.dogWalkingExperienceYn, "availabilityWithSize":request.availabilityWithSize, "introduction":request.introduction], encoding: JSONEncoding.default)
        }
    }
}
