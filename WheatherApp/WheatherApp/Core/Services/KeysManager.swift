//
//  KeysManager.swift
//  WheatherApp
//
//  Created by Anna Pomazanova on 03.04.2025.
//

import Foundation
import Security

class KeyManager {
    static let shared = KeyManager()

    private init() {}

    // Insecure method: Save key in UserDefaults
    func saveKeyInsecure(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    // Insecure method: Retrieve key from UserDefaults
    func retrieveKeyInsecure(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }

    // Secure method: Save key in Keychain (for comparison)
    func saveKeySecure(key: String, value: String) -> Bool {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        // Delete any existing item
        SecItemDelete(query as CFDictionary)

        // Add the new item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // Secure method: Retrieve key from Keychain (for comparison)
    func retrieveKeySecure(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}
