//
//  AddressListResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/12/25.
//

import Foundation

typealias AddressListResponse = APIResponse<[AddressList]>

struct AddressList: Codable {
    let addressId: Int
    let dongAddress: String
}
