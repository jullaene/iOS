//
//  MyPagePetModel.swift
//  walkmong
//
//  Created by 신호연 on 12/24/24.
//

struct MyPagePetModel: Decodable {
    let dogId: Int
    let dogName: String
    let dogProfile: String
    let dogGender: String
    let breed: String
    let weight: Double
}
