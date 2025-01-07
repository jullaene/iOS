//
//  MessageSendModel.swift
//  walkmong
//
//  Created by 황채웅 on 1/4/25.
//

import Foundation

struct MessageSendModel: Codable {
    let messageType: String
    let roomNumber: Int
    let msg: String
    let sendTime: String
}

