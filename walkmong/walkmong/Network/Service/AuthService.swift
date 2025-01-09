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
            throw NetworkError.clientError(message: "프로필 이미지를 변환할 수 없습니다.")
        }
        return try await provider.request(
            target: .signup(email: email, password: password, nickname: nickname, name: name, gender: gender, birthDate: birthDate, profile: profileData, phone: phone),
            responseType: AuthResponse.self
        )
    }

    func login(email: String, password: String) async throws -> RefreshAccessTokenResponse {
        do {
            return try await provider.request(
                target: .login(email: email, password: password),
                responseType: RefreshAccessTokenResponse.self
            )
        } catch let error as MoyaError {
            if case .statusCode(let response) = error, (400...499).contains(response.statusCode) {
                if let errorMessage = String(data: response.data, encoding: .utf8) {
                    throw NetworkError.clientError(message: errorMessage)
                }
            }
            throw error
        }
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
