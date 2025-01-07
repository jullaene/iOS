//
//  AuthService.swift
//  walkmong
//
//  Created by 황채웅 on 1/8/25.
//

import Foundation
import UIKit
import Moya

struct AuthService {
    private let provider = NetworkProvider<AuthAPI>()
    
    func signup(email: String, password: String, nickname: String, name: String, gender: String, birthDate: String, profile: UIImage, phone: String) async throws -> AuthResponse {
        guard let profileData = profile.jpegData(compressionQuality: 1.0) else {
            throw MoyaError.parameterEncoding("Failed to convert profile image to JPEG data." as! Error)
        }
        return try await provider.request(
            target: .signup(email: email, password: password, nickname: nickname, name: name, gender: gender, birthDate: birthDate, profile: profileData, phone: phone),
            responseType: AuthResponse.self
        )
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        return try await provider.request(
            target: .login(email: email, password: password),
            responseType: AuthResponse.self
        )
    }
    
    func checkEmail(email: String) async throws -> AuthResponse {
        return try await provider.request(
            target: .checkEmail(email: email),
            responseType: AuthResponse.self
        )
    }
    
    func checkNickname(nickname: String) async throws -> AuthResponse {
        return try await provider.request(
            target: .checkNickname(nickname: nickname),
            responseType: AuthResponse.self
        )
    }
    
    func verifyEmail(email: String) async throws -> AuthResponse {
        return try await provider.request(
            target: .veryfyEmail(email: email),
            responseType: AuthResponse.self
        )
    }
    
    func checkEmailAuthCode(email: String, code: String) async throws -> AuthResponse {
        return try await provider.request(
            target: .checkEmailAuthCode(email: email, code: code),
            responseType: AuthResponse.self
        )
    }
    
    func refreshAccessToken(refreshToken: String) async throws -> RefreshAccessTokenResponse {
        return try await provider.request(
            target: .refreshAccessToken(refreshToken: refreshToken),
            responseType: RefreshAccessTokenResponse.self
        )
    }
}
