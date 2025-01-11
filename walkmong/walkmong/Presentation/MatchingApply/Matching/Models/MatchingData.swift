//
//  MatchingData.swift
//
//  Created by 신호연 on 11/15/24.
//

import Foundation

struct BoardResponse: Codable {
    let message: String
    let statusCode: Int
    let data: [MatchingData]
}

struct MatchingData: Codable {
    let boardId: Int?
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
    let createdAt: String?

    // 계산 프로퍼티
    var date: String {
        return MatchingData.dateFormatter("yyyy-MM-dd HH:mm:ss.SSSSSS")
            .date(from: startTime)
            .flatMap { MatchingData.dateFormatter("MM. dd (EEE)").string(from: $0) } ?? "날짜 변환 오류"
    }

    var matchingStatus: String {
        matchingYn == "Y" ? "매칭확정" : "매칭중"
    }

    var formattedDistance: String {
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            let distanceInKm = distance / 1000
            if distanceInKm == floor(distanceInKm) {
                return "\(Int(distanceInKm))km"
            } else {
                return "\(String(format: "%.1f", distanceInKm))km"
            }
        }
    }
    
    var safeDogProfile: String {
        dogProfile ?? "puppyImage01.png"
    }

    var readableCreatedAt: String {
        guard let createdDate = MatchingData.dateFormatter("yyyy-MM-dd HH:mm:ss.SSSSSS").date(from: createdAt ?? "2024-11-16 04:30:00.000000") else {
            return "알 수 없음"
        }
        
        let now = Date()
        let elapsed = now.timeIntervalSince(createdDate)
        
        if elapsed < 600 {
            return "\(Int(elapsed / 60))분 전"
        } else if elapsed < 3600 {
            return "\(Int(elapsed / 60 / 10) * 10)분 전"
        } else if elapsed < 86400 {
            return "\(Int(elapsed / 3600))시간 전"
        } else {
            return "\(Int(elapsed / 86400))일 전"
        }
    }

    private static func dateFormatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
}
