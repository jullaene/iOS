//
//  MatchingApplyMapModel.swift
//  walkmong
//
//  Created by 황채웅 on 11/11/24.
//

import Foundation

struct MatchingApplyMapModel: Codable{
    var dongAddress: String?
    var roadAddress: String?
    var buildingName: String?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var didSelectLocation: Bool
    var memo: String?
}
