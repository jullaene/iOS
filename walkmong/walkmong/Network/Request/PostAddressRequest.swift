//
//  PostAddressRequest.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import Foundation

struct PostAddressRequest {
    let dongAddress: String
    let roadAddress: String
    let latitude: Double
    let longitude: Double
    let distanceRange: String
    let basicAddressYn: String
}
