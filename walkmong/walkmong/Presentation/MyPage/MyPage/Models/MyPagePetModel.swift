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
    let dogSize: String
    let dogGender: String
    let breed: String
    let weight: Double
}

struct PetProfile {
    let dogId: Int
    let imageURL: String?
    let name: String
    let details: String
    let gender: String
}
