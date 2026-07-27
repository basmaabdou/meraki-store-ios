import Foundation

/// قائمة الأخطاء المحتملة أثناء الاتصال بالشبكة أو معالجة البيانات
enum NetworkError: LocalizedError {
    case badURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
    case keychainError(status: OSStatus)
    case unauthorized
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "الرابط المستخدم غير صالح."
        case .invalidResponse:
            return "استجابة الخادم غير صالحة."
        case .serverError(let statusCode):
            return "خطأ في الخادم برمز استجابة: \(statusCode)."
        case .decodingError:
            return "فشل في فك تشفير البيانات."
        case .keychainError(let status):
            return "فشل في عملية الحفظ الآمن (Keychain Status: \(status))."
        case .unauthorized:
            return "اسم المستخدم أو كلمة المرور غير صحيحة."
        case .unknown:
            return "حدث خطأ غير معروف."
        }
    }
}
