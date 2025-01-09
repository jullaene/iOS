//
//  AuthService.swift
//  walkmong
//
//  Created by 황채웅 on 1/8/25.
//

import Foundation
import Moya

struct AuthService {
    private let provider = NetworkProvider<AuthAPI>()
    
    func signup(request: SignupRequest) async throws -> APIResponse<String> {
        return try await provider.request(
            target: .signup(request: request),
            responseType: APIResponse<String>.self
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
                throw NetworkError.clientError
            }
            throw error
        }
    }

    
    func checkEmail(email: String) async throws -> APIResponse<String> {
        return try await provider.request(
            target: .checkEmail(email: email),
            responseType: APIResponse<String>.self
        )
    }
    
    func checkNickname(nickname: String) async throws -> APIResponse<String> {
        return try await provider.request(
            target: .checkNickname(nickname: nickname),
            responseType: APIResponse<String>.self
        )
    }
    
    func verifyEmail(email: String) async throws -> APIResponse<String> {
        return try await provider.request(
            target: .veryfyEmail(email: email),
            responseType: APIResponse<String>.self
        )
    }
    
    func checkEmailAuthCode(email: String, code: String) async throws -> APIResponse<String> {
        return try await provider.request(
            target: .checkEmailAuthCode(email: email, code: code),
            responseType: APIResponse<String>.self
        )
    }
    
    func refreshAccessToken(refreshToken: String) async throws -> RefreshAccessTokenResponse {
        return try await provider.request(
            target: .refreshAccessToken(refreshToken: refreshToken),
            responseType: RefreshAccessTokenResponse.self
        )
    }
}
