//
//  APIResponse.swift
//  walkmong
//
//  Created by 신호연 on 11/15/24.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let message: String
    let statusCode: Int
    let data: T
}
