//
//  AuthAPI.swift
//  walkmong
//
//  Created by 황채웅 on 1/7/25.
//

import Foundation
import Moya

enum AuthAPI {
    case signup(email: String, password: String, nickname: String, name: String, gender: String, birthDate: String, profile: Data, phone: String)
    case login(email: String, password: String)
    case checkEmail(email: String)
    case checkNickname(nickname: String)
    case veryfyEmail(email: String)
    case checkEmailAuthCode(email: String, code: String)
    case refreshAccessToken(refreshToken: String)
}

extension AuthAPI: APIEndpoint {
    var method: Moya.Method {
        return .post
    }
    
    var headers: [String : String]? {
        switch self{
        case .signup:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/api/v1/auth/sign-up"
        case .login:
            return "/api/v1/auth/login"
        case .checkEmail:
            return "/api/v1/auth/email/duplicate"
        case .checkNickname:
            return "/api/v1/auth/nickname/duplicate"
        case .veryfyEmail:
            return "/api/v1/auth/email/code/request"
        case .checkEmailAuthCode:
            return "/api/v1/auth/email/code/verify"
        case .refreshAccessToken:
            return "/api/v1/auth/reissue/accesstoken"
        }
    }
    
    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .signup(email: let email, password: let password, nickname: let nickname, let name, gender: let gender, birthDate: let birthDate, profile: let profile, phone: let phone):
            let multipartData: [MultipartFormData] = [
                MultipartFormData(provider: .data(email.data(using: .utf8)!), name: "email"),
                MultipartFormData(provider: .data(password.data(using: .utf8)!), name: "password"),
                MultipartFormData(provider: .data(nickname.data(using: .utf8)!), name: "nickname"),
                MultipartFormData(provider: .data(name.data(using: .utf8)!), name: "name"),
                MultipartFormData(provider: .data(gender.data(using: .utf8)!), name: "gender"),
                MultipartFormData(provider: .data(birthDate.data(using: .utf8)!), name: "birthDate"),
                MultipartFormData(provider: .data(phone.data(using: .utf8)!), name: "phone"),
                MultipartFormData(provider: .data(profile), name: "profile", fileName: "profile.png", mimeType: "image/png")
            ]
            return .uploadMultipart(multipartData)
        case .checkEmail(let email), .veryfyEmail(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.queryString)
        case .checkNickname(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        case .checkEmailAuthCode(let email, code: let code):
            return .requestParameters(parameters: ["email": email, "code": code], encoding: URLEncoding.queryString)
        case .refreshAccessToken(let refreshToken):
            return .requestParameters(parameters: ["refreshToken": refreshToken], encoding: URLEncoding.queryString)
        }
    }
}
