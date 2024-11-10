//
//  ReverseGeocodingModel.swift
//  walkmong
//
//  Created by 황채웅 on 11/11/24.
//

import Foundation
//모델
struct ReverseGeocodingModel: Decodable {
    let results: [Address]
}
 
struct Address: Decodable {
    let region: Region
    let land: Land
}
 
struct Region: Decodable {
    let area1: Area1
    let area2, area3, area4: Area
}
 
struct Area1: Decodable {
    let name, alias: String
}
 
struct Area: Decodable {
    let name: String
}
 
struct Land: Decodable {
    let number1, number2: String
    let addition0: Addition0
    let name: String?
}
 
struct Addition0: Decodable {
    let type, value: String
}
