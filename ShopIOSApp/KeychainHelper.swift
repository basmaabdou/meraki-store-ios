
import Security
import Foundation

/// Helper class for securely saving, reading, and deleting tokens using the iOS Keychain
class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}
    
    private let service = "com.aurashop.app"
    private let account = "jwt-auth-token"
    
    /// Save token securely to Keychain
    func saveToken(_ token: String) -> Result<Void, NetworkError> {
        guard let data = token.data(using: .utf8) else { return .failure(.unknown) }
        
        // Delete existing item first to avoid duplicates
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
        
        // Create save query
        var attributes = query
        attributes[kSecValueData as String] = data
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            return .failure(.keychainError(status: status))
        }
        return .success(())
    }
    
    /// Retrieve saved token from Keychain
    func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        }
        return nil
    }
    
    /// Delete token from Keychain (e.g. on logout)
    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
            }
        }


