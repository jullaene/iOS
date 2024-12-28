//
//  KeychainManager.swift
//  walkmong
//
//  Created by 황채웅 on 12/28/24.
//

import Foundation
import Security

/// Access Token과 Refresh Token을 Keychain에서 안전하게 저장/조회/삭제합니다.
class KeychainManager {
    enum KeychainError: Error {
        case duplicateEntry
        case noToken
        case unknown(OSStatus)
    }
    
    /// Access Token 저장
    static func saveAccessToken(_ token: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "accessToken" as AnyObject,
            kSecValueData as String: token as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            // 기존 데이터 업데이트
            let updateQuery: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "accessToken" as AnyObject
            ]
            let updateData: [String: AnyObject] = [
                kSecValueData as String: token as AnyObject
            ]
            let updateStatus = SecItemUpdate(updateQuery as CFDictionary, updateData as CFDictionary)
            guard updateStatus == errSecSuccess else {
                throw KeychainError.unknown(updateStatus)
            }
        } else if status != errSecSuccess {
            throw KeychainError.unknown(status)
        }
    }
    
    /// Refresh Token 저장
    static func saveRefreshToken(_ token: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "refreshToken" as AnyObject,
            kSecValueData as String: token as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            // 기존 데이터 업데이트
            let updateQuery: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "refreshToken" as AnyObject
            ]
            let updateData: [String: AnyObject] = [
                kSecValueData as String: token as AnyObject
            ]
            let updateStatus = SecItemUpdate(updateQuery as CFDictionary, updateData as CFDictionary)
            guard updateStatus == errSecSuccess else {
                throw KeychainError.unknown(updateStatus)
            }
        } else if status != errSecSuccess {
            throw KeychainError.unknown(status)
        }
    }

    /// Token 가져오기
    static func getTokens() -> (accessToken: String?, refreshToken: String?) {
        /// Access Token 조회
        let accessQuery: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "accessToken" as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var accessResult: CFTypeRef?
        let accessStatus = SecItemCopyMatching(accessQuery as CFDictionary, &accessResult)
        let accessToken: String? = {
            guard accessStatus == errSecSuccess,
                  let data = accessResult as? Data,
                  let token = String(data: data, encoding: .utf8) else {
                return nil
            }
            return token
        }()
        
        /// Refresh Token 조회
        let refreshQuery: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "refreshToken" as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var refreshResult: CFTypeRef?
        let refreshStatus = SecItemCopyMatching(refreshQuery as CFDictionary, &refreshResult)
        let refreshToken: String? = {
            guard refreshStatus == errSecSuccess,
                  let data = refreshResult as? Data,
                  let token = String(data: data, encoding: .utf8) else {
                return nil
            }
            return token
        }()
        
        return (accessToken, refreshToken)
    }

    /// Access Token, Refresh Token 삭제
    static func deleteTokens() throws {
        let accessQuery: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "accessToken" as AnyObject
        ]
        let refreshQuery: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "refreshToken" as AnyObject
        ]
        
        let accessStatus = SecItemDelete(accessQuery as CFDictionary)
        let refreshStatus = SecItemDelete(refreshQuery as CFDictionary)
        
        guard accessStatus != errSecItemNotFound || refreshStatus != errSecItemNotFound else {
            throw KeychainError.noToken
        }
        
        guard accessStatus == errSecSuccess || refreshStatus == errSecSuccess else {
            throw KeychainError.unknown(accessStatus)
        }
    }
}
