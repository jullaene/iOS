//
//  AuthResponse.swift
//  walkmong
//
//  Created by 황채웅 on 1/8/25.
//

import Foundation

typealias AuthResponse = APIResponse<AuthData>

struct AuthData: Codable {
    let data: String
}
