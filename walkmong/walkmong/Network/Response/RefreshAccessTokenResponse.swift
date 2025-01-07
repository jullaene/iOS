//
//  RefreshAccessTokenResponse.swift
//  walkmong
//
//  Created by 황채웅 on 1/8/25.
//

import Foundation

typealias RefreshAccessTokenResponse = APIResponse<AccessToken>

struct AccessToken: Codable {
    let accessToken: String
    let refreshToken: String
}
