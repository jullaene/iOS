//
//  APIResponse.swift
//  walkmong
//
//  Created by 신호연 on 11/15/24.
//

import Foundation

struct APIResponse<DTO: Decodable>: Decodable {
    let message: String
    let statusCode: Int
    let data: DTO
}

enum NetworkError: Error {
    case unauthorized // RefreshToken 없음
    case tokenRefreshFailed // RefreshToken으로 갱신 실패
}
