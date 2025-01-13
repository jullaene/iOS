//
//  MessageSendModel.swift
//  walkmong
//
//  Created by 황채웅 on 1/4/25.
//

import Foundation

struct MessageReceivedModel: Codable {
    let messageType: String
    let roomNumber: Int
    let msg: String
    let sendTime: String
}

struct MessageSendModel: Codable {
    let roomId: Int
    let type: String
    let message: String
}

