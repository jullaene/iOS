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
    let dogProfile: String
    let dogSize: String
    let weight: Double
    let breed: String

    var formattedSize: String {
        switch dogSize {
        case "SMALL":
            return "소형견"
        case "MEDIUM":
            return "중형견"
        case "BIG":
            return "대형견"
        default:
            return "알 수 없음"
        }
    }

    var formattedWeight: String {
        if weight.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(weight))kg"
        } else {
            return String(format: "%.1f", weight) + "kg"
        }
    }

    var profileInformationText: String {
        return "\(formattedSize) · \(breed) · \(formattedWeight)"
    }
}
