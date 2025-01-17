//
//  GetCurrentLocationResponse.swift
//  walkmong
//
//  Created by 황채웅 on 1/17/25.
//

import Foundation

typealias GetCurrentLocationResponse = APIResponse<CurrentLocationItem>

struct CurrentLocationItem : Decodable {
    let latitude: Double
    let longitude: Double
    let lastSavedDt: String
}
