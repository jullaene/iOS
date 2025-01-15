//
//  MatchingApplyRequest.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import Foundation

struct WalkRequestData: Codable {
    var dongAddress: String = ""
    var roadAddress: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var addressDetail: String = ""
    var addressMemo: String = ""
    var poopBagYn: String = ""
    var muzzleYn: String = ""
    var dogCollarYn: String = ""
    var preMeetingYn: String = ""
    var memoToOwner: String = ""
}
