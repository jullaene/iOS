//
//  BoardListResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/11/25.
//

import Foundation

typealias BoardListResponse = APIResponse<[BoardList]>

struct BoardList: Codable {
    let boardId: Int
    let startTime: String
    let endTime: String
    let matchingYn: String
    let dogName: String
    let dogProfile: String
    let dogGender: String
    let breed: String
    let weight: Double
    let dogSize: String
    let content: String
    let dongAddress: String
    let distance: Double
    let createdAt: String
}

extension BoardList {

    var date: String {
        guard let date = BoardList.dateFormatter("yyyy-MM-dd HH:mm:ss.SSSSSS").date(from: startTime) else {
            return "날짜 변환 오류"
        }
        return BoardList.dateFormatter("MM. dd (EEE)").string(from: date)
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
        dogProfile
    }

    var readableCreatedAt: String {
        guard let createdDate = BoardList.dateFormatter("yyyy-MM-dd HH:mm:ss.SSSSSS").date(from: createdAt) else {
            return "알 수 없음"
        }
        return BoardList.elapsedTime(from: createdDate)
    }

    private static func elapsedTime(from date: Date) -> String {
        let now = Date()
        let elapsed = now.timeIntervalSince(date)

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

    private static var formatters: [String: DateFormatter] = [:]

    private static func dateFormatter(_ format: String) -> DateFormatter {
        if let formatter = formatters[format] {
            return formatter
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        formatters[format] = formatter
        return formatter
    }
}
