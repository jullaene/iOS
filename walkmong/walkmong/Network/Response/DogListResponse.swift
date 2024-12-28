//
//  DogListResponse.swift
//  walkmong
//
//  Created by 황채웅 on 12/28/24.
//

import Foundation

typealias DogListResponse = APIResponse<[DogListItem]>

struct DogListItem: Codable {
    let dogId: Int
    let dogName: String
    let dogProfile: String?
    let dogSize: String
    let dogGender: String
    let breed: String
    let weight: Double
}
