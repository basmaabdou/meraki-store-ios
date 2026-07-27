import Foundation

enum AuthState {
    case idle
    case loading
    case success(User)
    case failed(String)
}

class AuthViewModel: ObservableObject {
    @Published var state: AuthState = .idle
    @Published var email = ""
    @Published var password = ""
    
    private let loginURL = "https://dummyjson.com/auth/login"
    
    func login() {
        guard !email.isEmpty && !password.isEmpty else {
            self.state = .failed("Please enter your email and password.")
            return
        }
        
        self.state = .loading
        
        let credentials = ["username": email, "password": password]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: credentials) else {
            self.state = .failed("Failed to process request data.")
            return
        }
        
        NetworkManager.shared.request(urlString: loginURL, method: "POST", body: bodyData) { (result: Result<User, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    if let token = user.token {
                        let saveResult = KeychainHelper.shared.saveToken(token)
                        switch saveResult {
                        case .success:
                            self.state = .success(user)
                        case .failure(let error):
                            self.state = .failed(error.localizedDescription)
                        }
                    } else {
                        self.state = .success(user)
                    }
                case .failure(let error):
                    self.state = .failed(error.localizedDescription)
                }
            }
        }
    }
}
