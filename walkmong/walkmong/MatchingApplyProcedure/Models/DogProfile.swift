//
//  DogProfile.swift
//  walkmong
//
//  Created by 신호연 on 11/12/24.
//

import Foundation

struct DogProfile {
    let dogId: Int
    let dogName: String
    let dogGender: String
    let dogAge: Int
    let breed: String
    let weight: Double
    let neuteringYn: Bool
    let bite: Bool
    let friendly: Bool
    let barking: Bool
    let rabiesYn: Bool
    
    init(dogId: Int,
         dogName: String,
         dogGender: String,
         dogAge: Int,
         breed: String,
         weight: Double,
         neuteringYn: Bool,
         bite: Bool,
         friendly: Bool,
         barking: Bool,
         rabiesYn: Bool) {
        self.dogId = dogId
        self.dogName = dogName
        self.dogGender = dogGender
        self.dogAge = dogAge
        self.breed = breed
        self.weight = weight
        self.neuteringYn = neuteringYn
        self.bite = bite
        self.friendly = friendly
        self.barking = barking
        self.rabiesYn = rabiesYn
    }
}
