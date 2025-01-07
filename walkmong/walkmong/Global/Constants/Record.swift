//
//  Record.swift
//  walkmong
//
//  Created by 황채웅 on 1/3/25.
//

import Foundation

enum Record: String {
    case applied = "지원한 산책"
    case requested = "의뢰한 산책"
    case all = "전체"
    
    static func from(index: Int) -> Record {
        switch index {
        case 0: return .all
        case 1: return .applied
        case 2: return .requested
        default: return .all
        }
    }
}
