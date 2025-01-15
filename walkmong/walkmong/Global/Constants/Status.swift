//
//  Status.swift
//  walkmong
//
//  Created by 황채웅 on 1/3/25.
//

import Foundation
import UIKit

enum Status: String {
    case PENDING = "매칭중"
    case BEFORE = "매칭확정"
    case AFTER = "산책완료"
    case REJECT = "매칭취소"
    
    static func from(index: Int) -> Status {
        switch index {
        case 0: return .PENDING
        case 1: return .BEFORE
        case 2: return .AFTER
        case 3: return .REJECT
        default: return .PENDING
        }
    }
    var backgroundColor: UIColor {
        switch self {
        case .PENDING: return .lightBlue
        case .BEFORE: return .mainBlue
        case .AFTER: return .gray400
        case .REJECT: return .gray200
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .PENDING: return .mainBlue
        case .BEFORE, .AFTER: return .white
        case .REJECT: return .gray400
        }
    }

}
