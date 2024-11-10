//
//  NSObject+.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
