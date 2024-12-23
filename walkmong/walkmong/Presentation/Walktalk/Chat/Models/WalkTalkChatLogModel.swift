//
//  WalkTalkChatLogModel.swift
//  walkmong
//
//  Created by 황채웅 on 12/19/24.
//

import Foundation

struct WalkTalkChatLogModel{
    var matchingState: String
    
    let dogName: String
    let date: String
    let id: String
    let data: [WalkTalkChatMessageModel?]?
}

struct WalkTalkChatMessageModel: Codable {
    let type: String?
    let text: String?
    let id: String?
    let date: String?
}

extension WalkTalkChatLogModel {
    // 날짜 포맷터
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS" // 입력 형식
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    // 날짜 출력 포맷터
    static let outputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일" // 출력 형식
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    // 시간 출력 포맷터
    static let outputTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm" // 오전/오후 h:mm 형식
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    // 섹션화된 데이터 반환
    func sectionedChatMessages() -> [(sectionTitle: String, messages: [WalkTalkChatMessageModel])] {
        // 1. 메시지가 nil이 아닌 경우만 필터링
        guard let data = data else { return [] }
        let filteredMessages = data.compactMap { $0 }
        
        // 2. 메시지 정렬
        let sortedMessages = filteredMessages.sorted { lhs, rhs in
            guard let lhsDateStr = lhs.date, let rhsDateStr = rhs.date,
                  let lhsDate = WalkTalkChatLogModel.dateFormatter.date(from: lhsDateStr),
                  let rhsDate = WalkTalkChatLogModel.dateFormatter.date(from: rhsDateStr) else {
                return false
            }
            return lhsDate < rhsDate
        }
        
        // 3. 메시지를 날짜별로 그룹화
        let groupedMessages = Dictionary(grouping: sortedMessages) { message -> String in
            guard let dateStr = message.date,
                  let date = WalkTalkChatLogModel.dateFormatter.date(from: dateStr) else {
                return "Unknown Date"
            }
            return WalkTalkChatLogModel.outputDateFormatter.string(from: date) // "yyyy년 M월 d일"
        }
        
        // 4. 섹션화된 데이터 생성
        let sectionedMessages = groupedMessages.map { (key, value) -> (String, [WalkTalkChatMessageModel]) in
            (key, value)
        }.sorted { lhs, rhs in
            return lhs.0 < rhs.0 // 섹션 제목 기준 정렬
        }
        
        return sectionedMessages
    }
    
    func formattedTime() -> String {
        guard let date = WalkTalkChatLogModel.dateFormatter.date(from: self.date) else {
            return self.date
        }
        return WalkTalkChatLogModel.outputTimeFormatter.string(from: date) // "오전/오후 h:mm"
    }
}
