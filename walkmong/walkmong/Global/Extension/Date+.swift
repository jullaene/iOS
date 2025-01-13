//
//  Date+.swift
//  walkmong
//
//  Created by 황채웅 on 1/4/25.
//

import Foundation

extension Date {
    static func currentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS" // 원하는 형식
        formatter.locale = Locale(identifier: "ko_KR") // 한국 시간대
        formatter.timeZone = TimeZone.current
        return formatter.string(from: Date()) // 현재 시간 반환
    }
    
    static func formattedDate(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
}
