//
//  Date+Extensions.swift
//  walkmong
//
//  Created by 황채웅 on 1/4/25.
//

import Foundation

extension Date {
    // 현재 타임스탬프 반환
    static func currentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: Date())
    }

    // 주어진 날짜를 원하는 포맷으로 변환
    static func formattedDate(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
}

extension ISO8601DateFormatter {
    static let shared: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    // ISO8601 문자열을 Date로 변환
    static func date(from isoString: String) -> Date? {
        return shared.date(from: isoString)
    }

    // Date를 ISO8601 문자열로 변환
    static func string(from date: Date) -> String {
        return shared.string(from: date)
    }
}

extension DateFormatter {
    static let display: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd (EEE)\nHH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}
