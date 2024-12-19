//
//  WalkTalkChatLogModel.swift
//  walkmong
//
//  Created by 황채웅 on 12/19/24.
//

import Foundation

struct WalkTalkChatLogModel{
    var matchingState: String
    
    let dogName: String
    let date: String
    let id: String
    let data: [WalkTalkChatMessageModel]
}

struct WalkTalkChatMessageModel: Codable{
    let type: String
    let text: String
    let id: String
    let date: String
}
