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
}

extension MemberAPI: APIEndpoint {
    var path: String {
        switch self {
             case .postAddress: return "/api/v1/address"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .postAddress: return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postAddress(let request):
            return .requestParameters(parameters: ["dongAddress": request.dongAddress, "roadAddress": request.roadAddress, "latitude": request.latitude, "longitude": request.longitude, "distanceRange": request.distanceRange, "basicAddressYn": request.basicAddressYn], encoding: JSONEncoding.default)
        }
    }
}
