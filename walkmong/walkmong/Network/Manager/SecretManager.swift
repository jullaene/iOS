//
//  SecretManager.swift
//  walkmong
//
//  Created by 신호연 on 11/14/24.
//

import Foundation

class SecretManager {
    static let shared = SecretManager()
    private var secrets: [String: Any]?

    private init() {
        if let path = Bundle.main.path(forResource: "Secret", ofType: "plist"),
           let data = FileManager.default.contents(atPath: path) {
            do {
                secrets = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any]
            } catch {
                print("Secret.plist 읽기 실패: \(error)")
            }
        }
    }

    func getValue(forKey key: String) -> String? {
        return secrets?[key] as? String
    }
}
