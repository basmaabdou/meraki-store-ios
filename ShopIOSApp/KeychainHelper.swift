
import Security
import Foundation

/// فئة مساعدة لحفظ وقراءة وحذف الـ Token بأمان داخل نظام الـ iOS Keychain
class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}
    
    private let service = "com.aurashop.app"
    private let account = "jwt-auth-token"
    
    /// حفظ الـ Token بأمان
    func saveToken(_ token: String) -> Result<Void, NetworkError> {
        guard let data = token.data(using: .utf8) else { return .failure(.unknown) }
        
        // استعلام للبحث والمسح أولاً لتجنب التكرار
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
        
        // استعلام الحفظ الجديد
        var attributes = query
        attributes[kSecValueData as String] = data
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            return .failure(.keychainError(status: status))
        }
        return .success(())
    }
    
    /// استرجاع الـ Token المحفوظ
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
    
    /// حذف الـ Token عند تسجيل الخروج
    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
            }
        }


