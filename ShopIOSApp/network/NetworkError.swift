import Foundation

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
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)."
        case .decodingError:
            return "Failed to decode data."
        case .keychainError(let status):
            return "Keychain operation failed (Status: \(status))."
        case .unauthorized:
            return "Invalid username or password."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
