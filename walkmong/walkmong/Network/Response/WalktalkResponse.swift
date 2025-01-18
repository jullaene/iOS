//
//  WalktalkResponse.swift
//  walkmong
//
//  Created by 황채웅 on 1/3/25.
//

import Foundation

typealias CreateChatroomResponse = APIResponse<Int?>

typealias GetHistoryResponse = APIResponse<[HistoryItem]>

struct HistoryItem: Decodable {
    let message: String
    let senderId: Int
    let createdAt: String
}

typealias GetChatroomResponse = APIResponse<[ChatroomResponseData]>

struct ChatroomResponseData: Decodable {
    var tabStatus: String
    var dogName: String
    var dogProfile: String
    var startTime: String
    var endTime: String
    var chatTarget: Int
    var lastChat: String?
    var lastChatTime: String?
    var targetName: String
    var notRead: Int
    var roomId: Int
}


func formatDateRange(start: String, end: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS" // 입력 형식
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "MM.dd (E) HH:mm" // 원하는 출력 형식
    outputFormatter.locale = Locale(identifier: "ko_KR")
    
    guard let startDate = inputFormatter.date(from: start),
          let endDate = inputFormatter.date(from: end) else {
        return "\(start) ~ \(end)" // 변환 실패 시 원래 값 반환
    }
    
    let startString = outputFormatter.string(from: startDate)
    let endTimeFormatter = DateFormatter()
    endTimeFormatter.dateFormat = "HH:mm" // 끝나는 시간은 시간:분만 표시
    let endString = endTimeFormatter.string(from: endDate)
    
    return "\(startString) ~ \(endString)"
}

func formatLastChatTime(_ time: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS" // 입력 형식
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "a hh:mm" // 오전/오후 시간 형식
    outputFormatter.locale = Locale(identifier: "ko_KR")
    
    guard let date = inputFormatter.date(from: time) else {
        return time // 변환 실패 시 원래 값 반환
    }
    
    return outputFormatter.string(from: date)
}


extension HistoryItem {
    // 입력 날짜 포맷터
    static let inputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    // 출력 날짜 포맷터 (섹션 제목)
    static let outputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    // 출력 시간 포맷터 (채팅 시간)
    static let outputTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm" // 오전/오후 h:mm
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}

extension Array where Element == HistoryItem {
    func sectionedChatMessages() -> [(sectionTitle: String, messages: [HistoryItem])] {
        // 1. 메시지를 날짜로 그룹화
        let groupedMessages = Dictionary(grouping: self) { message -> String in
            guard let date = HistoryItem.inputDateFormatter.date(from: message.createdAt) else {
                return "Unknown Date"
            }
            return HistoryItem.outputDateFormatter.string(from: date) // 섹션 제목
        }
        
        // 2. 섹션별 메시지 정렬
        let sortedSections = groupedMessages.map { (key, value) -> (String, [HistoryItem]) in
            let sortedMessages = value.sorted { lhs, rhs in
                guard let lhsDate = HistoryItem.inputDateFormatter.date(from: lhs.createdAt),
                      let rhsDate = HistoryItem.inputDateFormatter.date(from: rhs.createdAt) else {
                    return false
                }
                return lhsDate < rhsDate // 시간순 정렬
            }
            return (key, sortedMessages)
        }
        
        // 3. 섹션 제목 기준으로 정렬
        return sortedSections.sorted { lhs, rhs in
            guard let lhsDate = HistoryItem.outputDateFormatter.date(from: lhs.0),
                  let rhsDate = HistoryItem.outputDateFormatter.date(from: rhs.0) else {
                return false
            }
            return lhsDate < rhsDate
        }
    }
}
