//
//  MatchingData.swift
//  walkmong
//
//  Created by 신호연 on 11/10/24.
//

import Foundation

struct BoardResponse: Codable {
    let message: String
    let statusCode: Int
    let data: [MatchingData]
}

struct MatchingData: Codable {
    let startTime: String
    let endTime: String
    let matchingYn: String
    let dogName: String
    let dogProfile: String?
    let dogGender: String
    let breed: String
    let weight: Double
    let dogSize: String
    let content: String
    let dongAddress: String
    let distance: Double
    let createdAt: String

    // 계산 프로퍼티
    var date: String {
        let components = startTime.split(separator: " ")
        return components.first.map { String($0) } ?? ""
    }

    var matchingStatus: String {
        return matchingYn == "Y" ? "매칭확정" : "매칭중"
    }

    var formattedDistance: String {
        return distance >= 1.0 ? "\(String(format: "%.1f", distance))km" : "\(Int(distance * 1000))m"
    }

    var safeDogProfile: String {
        return dogProfile ?? "puppyImage01.png"
    }

    // 디코딩 중 null 값을 처리하기 위한 커스텀 init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startTime = try container.decode(String.self, forKey: .startTime)
        self.endTime = try container.decode(String.self, forKey: .endTime)
        self.matchingYn = try container.decode(String.self, forKey: .matchingYn)
        self.dogName = try container.decode(String.self, forKey: .dogName)
        self.dogProfile = try? container.decode(String.self, forKey: .dogProfile) // null 허용
        self.dogGender = try container.decode(String.self, forKey: .dogGender)
        self.breed = try container.decode(String.self, forKey: .breed)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.dogSize = try container.decode(String.self, forKey: .dogSize)
        self.content = try container.decode(String.self, forKey: .content)
        self.dongAddress = try container.decode(String.self, forKey: .dongAddress)
        self.distance = try container.decode(Double.self, forKey: .distance)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
    }
}
