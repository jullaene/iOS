//
//  PostDogInfoRequest.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import Foundation
import Moya
import UIKit

struct PostDogInfoRequest {
    var name: String = ""
    var dogSize: String = ""
    var profile: UIImage = UIImage()
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
            "name": name, "dogSize": dogSize, "gender": gender,
            "birthYear": birthYear, "breed": breed, "weight": weight,
            "neuteringYn": neuteringYn, "bite": bite, "friendly": friendly,
            "barking": barking, "rabiesYn": rabiesYn, "adultYn": adultYn,
            "walkRequest": walkRequest, "walkNote": walkNote, "additionalRequest": additionalRequest
        ]
        
        for (key, value) in fields {
            formData.append(MultipartFormData(provider: .data(value.data(using: .utf8) ?? Data()), name: key))
        }
        
        if let profileData = profile.jpegData(compressionQuality: 1.0) {
            let uniqueFileName = "\(UUID().uuidString).jpg"
            formData.append(
                MultipartFormData(
                    provider: .data(profileData),
                    name: "profile",
                    fileName: uniqueFileName,
                    mimeType: "image/jpeg"
                )
            )
        } else {
            print("프로필 이미지 압축 실패")
        }
        
        return formData
    }
}
