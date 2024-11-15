//
//  GeocodingModel.swift
//  walkmong
//
//  Created by 황채웅 on 11/16/24.
//

import Foundation

struct Geocoding: Codable {
    let status: String
    let meta: Meta
    let addresses: [GeoAddress]
    let errorMessage: String
}
 
struct GeoAddress: Codable {
    let roadAddress, jibunAddress, englishAddress: String
    let addressElements: [AddressElement]
    let x, y: String
    let distance: Double
}
 
struct AddressElement: Codable {
    let types: [String]
    let longName, shortName, code: String
}
 
struct Meta: Codable {
    let totalCount, page, count: Int
}
