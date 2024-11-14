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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS" // 서버에서 전달되는 형식
        formatter.locale = Locale(identifier: "ko_KR")
        
        // 변환 시도
        guard let date = formatter.date(from: startTime) else {
            return "날짜 변환 오류"
        }
        
        // 원하는 형식으로 변환
        formatter.dateFormat = "MM. dd (EEE)"
        return formatter.string(from: date)
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

    var translatedDogSize: String {
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

    var readableCreatedAt: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "ko_KR")
        
        guard let createdDate = formatter.date(from: createdAt) else {
            return "알 수 없음"
        }
        
        let now = Date()
        let elapsed = now.timeIntervalSince(createdDate)

        if elapsed < 600 {
            let minutes = Int(elapsed / 60)
            return "\(minutes)분 전"
        } else if elapsed < 3600 {
            let minutes = Int(elapsed / 60 / 10) * 10
            return "\(minutes)분 전"
        } else if elapsed < 86400 {
            let hours = Int(elapsed / 3600)
            return "\(hours)시간 전"
        } else {
            let days = Int(elapsed / 86400)
            return "\(days)일 전"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startTime = try container.decode(String.self, forKey: .startTime)
        self.endTime = try container.decode(String.self, forKey: .endTime)
        self.matchingYn = try container.decode(String.self, forKey: .matchingYn)
        self.dogName = try container.decode(String.self, forKey: .dogName)
        self.dogProfile = try? container.decode(String.self, forKey: .dogProfile)
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
