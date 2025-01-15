//
//  Record.swift
//  walkmong
//
//  Created by 황채웅 on 1/3/25.
//

import Foundation

enum Record: String {
    case APPLY = "지원한 산책"
    case BOARD = "의뢰한 산책"
    case ALL = "전체"
    
    static func from(index: Int) -> Record {
        switch index {
        case 0: return .ALL
        case 1: return .APPLY
        case 2: return .BOARD
        default: return .ALL
        }
    }
}
