import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(
        urlString: String,
        method: String = "GET",
        body: Data?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = KeychainHelper.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        logRequest(request)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                self.logResponse(httpResponse, data: data, error: error)
            }
            
            if let _ = error {
                completion(.failure(.unknown))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodingError))
                }
            case 401:
                completion(.failure(.unauthorized))
            default:
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
            }
        }
        
        task.resume()
    }
    
    private func logRequest(_ request: URLRequest) {
        print("\n--- 🚀 HTTP REQUEST ---")
        print("URL: \(request.url?.absoluteString ?? "Unknown")")
        print("Method: \(request.httpMethod ?? "Unknown")")
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Request Headers: \(headers)")
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Request Body: \(bodyString)")
        }
        print("-----------------------\n")
    }
    
    private func logResponse(_ response: HTTPURLResponse, data: Data?, error: Error?) {
        print("\n--- 📥 HTTP RESPONSE ---")
        print("Status Code: \(response.statusCode)")
        print("URL: \(response.url?.absoluteString ?? "Unknown")")
        print("Headers: \(response.allHeaderFields)")
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        
        if let data = data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("Response Body (JSON):\n\(prettyString)")
            } else if let rawString = String(data: data, encoding: .utf8) {
                print("Response Body (Raw):\n\(rawString)")
            }
        } else {
            print("Response Body: Empty")
        }
        print("-----------------------\n")
    }
}
