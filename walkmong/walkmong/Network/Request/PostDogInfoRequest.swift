//
//  PostDogInfoRequest.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import Foundation
import Moya

struct PostDogInfoRequest {
    var memberId: String = ""
    var name: String = ""
    var dogSize: String = ""
    var profile: String = ""
    var gender: String = ""
    var birthYear: String = ""
    var breed: String = ""
    var weight: String = ""
    var neuteringYn: String = ""
    var bite: String = ""
    var friendly: String = ""
    var barking: String = ""
    var rabiesYn: String = ""
    var adultYn: String = ""
    var walkRequest: String = ""
    var walkNote: String = ""
    var additionalRequest: String = ""
}

extension PostDogInfoRequest {
    func toMultipartData() -> [MultipartFormData] {
        var formData: [MultipartFormData] = []
        
        let fields = [
            "memberId": memberId, "name": name, "dogSize": dogSize, "gender": gender,
            "birthYear": birthYear, "breed": breed, "weight": weight,
            "neuteringYn": neuteringYn, "bite": bite, "friendly": friendly,
            "barking": barking, "rabiesYn": rabiesYn, "adultYn": adultYn,
            "walkRequest": walkRequest, "walkNote": walkNote, "additionalRequest": additionalRequest
        ]
        
        for (key, value) in fields {
            formData.append(MultipartFormData(provider: .data(value.data(using: .utf8) ?? Data()), name: key))
        }
        
        if let fileURL = URL(string: profile), let imageData = try? Data(contentsOf: fileURL) {
            formData.append(
                MultipartFormData(provider: .data(imageData), name: "profile", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            )
        }
        
        return formData
    }
}
