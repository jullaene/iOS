//
//  APIEndpoint.swift
//  walkmong
//
//  Created by 황채웅 on 12/28/24.
//

import Foundation
import Moya

protocol APIEndpoint: TargetType {}

extension APIEndpoint {
    /// TargetType 중 baseURL을 미리 설정합니다.
    var baseURL: URL {
        guard let urlString = SecretManager.shared.BASE_URL,
              let url = URL(string: urlString) else {
            fatalError("BASE_URL이 설정되지 않았거나 유효하지 않습니다!")
        }
        return url
    }

    /// TargetType 중 header의 토큰을 미리 설정합니다.
    var headers: [String: String]? {
        guard let token = AuthManager.shared.accessToken else {
            /// Access Token이 없는 경우
            return ["Content-Type": "application/json"]
        }
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }

}
