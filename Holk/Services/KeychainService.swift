import Foundation
import Security

final class KeychainService {
    static func set(password: String, account: String, service: String) {
        guard let data = password.data(using: .utf8) else { return }
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ] as CFDictionary
        
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }
    
    static func get(account: String, service: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var buffer: AnyObject?
        if SecItemCopyMatching(query, &buffer) == errSecSuccess {
            if let data = buffer as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        
        return nil
    }
    
    static func delete(account: String, service: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
            ] as CFDictionary
        
        SecItemDelete(query)
    }
}
