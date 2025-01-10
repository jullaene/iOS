//
//  Status.swift
//  walkmong
//
//  Created by 황채웅 on 1/3/25.
//

import Foundation

enum Status: String {
    case PENDING = "매칭중"
    case CONFIRMED = "매칭확정"
    case COMPLETED = "산책완료"
    case REJECTED = "매칭취소"
    
    static func from(index: Int) -> Status {
        switch index {
        case 0: return .PENDING
        case 1: return .CONFIRMED
        case 2: return .COMPLETED
        case 3: return .REJECTED
        default: return .PENDING
        }
    }
}
