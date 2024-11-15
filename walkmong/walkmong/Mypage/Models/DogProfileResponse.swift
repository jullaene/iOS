//
//  DogProfileResponse.swift
//  walkmong
//
//  Created by 신호연 on 11/15/24.
//

import Foundation

struct DogProfileResponse: Decodable {
    let dogId: Int
    let dogName: String
    let dogProfile: String
    let dogGender: String
    let dogAge: Int
    let breed: String
    let weight: Double
    let neuteringYn: String
    let bite: String
    let friendly: String
    let barking: String
    let rabiesYn: String
}
