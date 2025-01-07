//
//  WalkTalkChatLogModel.swift
//  walkmong
//
//  Created by 황채웅 on 12/19/24.
//

import Foundation

struct WalkTalkChatLogModel{
    var matchingState: Status
    let dogName: String
    let date: String
    let roomId: Int
    let profileImageUrl: String
    let data: [MessageSendModel?]?
}
