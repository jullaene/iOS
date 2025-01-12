//
//  MemberWalkingResponse.swift
//  walkmong
//
//  Created by 신호연 on 1/11/25.
//

import Foundation

typealias MemberWalking = APIResponse<MemberWalkingItem>

struct MemberWalkingItem: Codable {
    let name: String
    let profile: String
    let dogOwnership: DogOwnership
    let dogWalkingExperience: Int
    let availabilityWithSize: String
    let walkerReviewCount: Int
    let photoSharing: Float
    let attitude: Float
    let taskCompletion: Float
    let timePunctuality: Float
    let communication: Float
    let tags: [Tag]
    let ownerReviewCount: Int
    let goodPercent: Int

    struct Tag: Codable {
        let hashtagNm: MemberWalkingTagEnum
        let goodPercent: Int
    }
}

struct MemberWalkingTag: Codable {
    let hashtagNm: String
    let keywordPercent: Int
}

enum MemberWalkingTagEnum: String, Codable {
    case likedByDog = "LIKED_BY_DOG"
    case polite = "POLITE"
    case detailOriented = "DETAIL_ORIENTED"
    case goodScheduleManagement = "GOOD_SCHEDULE_MANAGEMENT"
    case responsibleWalking = "RESPONSIBLE_WALKING"
    case goodWithDogs = "GOOD_WITH_DOGS"
    case fastResponse = "FAST_RESPONSE"
    case followsRequests = "FOLLOWS_REQUESTS"
    case reliable = "RELIABLE"
    case safeWalking = "SAFE_WALKING"
    case professional = "PROFESSIONAL"
    
    var description: String {
        switch self {
        case .likedByDog: return "반려견이 좋아해요"
        case .polite: return "매너가 좋아요"
        case .detailOriented: return "꼼꼼해요"
        case .goodScheduleManagement: return "일정 조정을 잘 해줘요"
        case .responsibleWalking: return "산책을 성실히 해줘요"
        case .goodWithDogs: return "반려견을 잘 다뤄요"
        case .fastResponse: return "답장이 빨라요"
        case .followsRequests: return "요청 사항을 잘 들어줘요"
        case .reliable: return "믿고 맡길 수 있어요"
        case .safeWalking: return "안전한 산책을 제공해요"
        case .professional: return "전문적으로 느껴져요"
        }
    }
}

enum DogOwnership: String, Codable {
    case none = "NONE"
    case lessThan3 = "LESS_THAN_3"
    case moreThan3 = "MORE_THAN_3"
    case moreThan5 = "MORE_THAN_5"
    case moreThan10 = "MORE_THAN_10"
    
    var description: String {
        switch self {
        case .none: return "없음"
        case .lessThan3: return "3년 미만"
        case .moreThan3: return "3년 이상"
        case .moreThan5: return "5년 이상"
        case .moreThan10: return "10년 이상"
        }
    }
}
