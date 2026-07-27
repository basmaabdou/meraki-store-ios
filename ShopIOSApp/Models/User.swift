import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let image: String
    let token: String?
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
