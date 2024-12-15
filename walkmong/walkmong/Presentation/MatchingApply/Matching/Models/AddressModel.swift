//
//  AddressModel.swift
//  walkmong
//
//  Created by 신호연 on 11/14/24.
//

import Foundation

struct BoardAddress: Decodable {
    let addressId: Int
    let dongAddress: String
}

struct AddressResponse: Decodable {
    let message: String
    let statusCode: Int
    let data: [BoardAddress]
}
