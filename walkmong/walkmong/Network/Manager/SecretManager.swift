//
//  SecretManager.swift
//  walkmong
//
//  Created by 신호연 on 11/14/24.
//

import Foundation

@dynamicMemberLookup
class SecretManager {
    static let shared = SecretManager()
    private var secrets: [String: Any]?

    private init() {
        loadSecrets()
    }

    private func loadSecrets() {
        guard let path = Bundle.main.path(forResource: "Secret", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path) else {
            print("Secret.plist 파일을 찾을 수 없습니다.")
            return
        }

        do {
            secrets = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any]
        } catch {
            print("Secret.plist 읽기 실패: \(error)")
        }
    }

    subscript(dynamicMember member: String) -> String? {
        return secrets?[member] as? String
    }
}
