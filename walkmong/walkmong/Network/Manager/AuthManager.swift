//
//  AuthManager.swift
//  walkmong
//
//  Created by 황채웅 on 12/28/24.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    private init() {}

    /// Access Token 프로퍼티
    var accessToken: String? {
        get {
            // KeychainManager에서 Access Token 가져오기
            return KeychainManager.getTokens().accessToken
        }
        set {
            if let newToken = newValue {
                // Access Token 저장
                try? KeychainManager.saveAccessToken(newToken.data(using: .utf8)!)
            } else {
                // Access Token 삭제
                try? KeychainManager.deleteTokens()
            }
        }
    }

    /// Refresh Token 프로퍼티
    var refreshToken: String? {
        get {
            // KeychainManager에서 Refresh Token 가져오기
            return KeychainManager.getTokens().refreshToken
        }
        set {
            if let newToken = newValue {
                // Refresh Token 저장
                try? KeychainManager.saveRefreshToken(newToken.data(using: .utf8)!)
            } else {
                // Refresh Token 삭제
                try? KeychainManager.deleteTokens()
            }
        }
    }
    
    func isLoggedIn() -> Bool {
        return accessToken != nil
    }
}
