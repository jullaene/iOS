//
//  MatchingApplyDetailSelectModel.swift
//  walkmong
//
//  Created by 황채웅 on 11/9/24.
//

import Foundation

struct MatchingApplyDetailSelectModel: Codable{
    var dogInformationChecked: Bool
    var dateChecked: Bool
    var placeSelected: MatchingApplyMapModel?
    var envelopeNeeded: Bool?
    var mouthCoverNeeded: Bool?
    var leadStringNeeded: Bool?
    var preMeetingNeeded: Bool?
    var nextButtonEnabled: Bool
    var placeMemo: String?
}
