//
//  SignupRequest.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import Foundation
import UIKit
import Moya

struct SignupRequest {
    var email: String
    var password: String
    var nickname: String
    var name: String
    var gender: String
    var birthDate: String
    var profile: UIImage
    var phone: String
    
    init(
        email: String = "",
        password: String = "",
        nickname: String = "",
        name: String = "",
        gender: String = "",
        birthDate: String = "",
        profile: UIImage = UIImage(),
        phone: String = ""
    ) {
        self.email = email
        self.password = password
        self.nickname = nickname
        self.name = name
        self.gender = gender
        self.birthDate = birthDate
        self.profile = profile
        self.phone = phone
    }
    
    func toMultipartData() -> [MultipartFormData] {
        var multipartData: [MultipartFormData] = []
        multipartData.append(MultipartFormData(provider: .data(email.data(using: .utf8)!), name: "email"))
        multipartData.append(MultipartFormData(provider: .data(password.data(using: .utf8)!), name: "password"))
        multipartData.append(MultipartFormData(provider: .data(nickname.data(using: .utf8)!), name: "nickname"))
        multipartData.append(MultipartFormData(provider: .data(name.data(using: .utf8)!), name: "name"))
        multipartData.append(MultipartFormData(provider: .data(gender.data(using: .utf8)!), name: "gender"))
        multipartData.append(MultipartFormData(provider: .data(birthDate.data(using: .utf8)!), name: "birthDate"))
        multipartData.append(MultipartFormData(provider: .data(phone.data(using: .utf8)!), name: "phone"))
        if let profileData = profile.jpegData(compressionQuality: 1.0) {
            multipartData.append(MultipartFormData(provider: .data(profileData), name: "profile", fileName: "profile.jpg", mimeType: "image/jpeg"))
        }
        return multipartData
    }
}
