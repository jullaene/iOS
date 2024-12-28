//
//  DogInfoResponse.swift
//  walkmong
//
//  Created by 황채웅 on 12/28/24.
//

import Foundation

typealias DogInfoResponse = APIResponse<DogInfo>

struct DogInfo: Codable {
    let dogId: Int
    let dogName: String
    let dogProfile: String?
    let dogGender: String
    let dogAge: Int
    let breed: String
    let weight: Int
    let neuteringYn: String
    let bite: String
    let friendly: String
    let barking: String
    let rabiesYn: String
}
