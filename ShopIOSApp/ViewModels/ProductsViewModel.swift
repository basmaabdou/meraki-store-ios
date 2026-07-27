import Foundation

enum ProductsState {
    case idle
    case loading
    case success([Product])
    case failed(String)
}

class ProductsViewModel: ObservableObject {
    @Published var state: ProductsState = .idle
    @Published var searchText: String = ""
    
    private let productsURL = "https://dummyjson.com/products"
    private var allProducts: [Product] = []
    
    func fetchProducts() {
        self.state = .loading
        
        NetworkManager.shared.request(urlString: productsURL, method: "GET", body: nil) { (result: Result<ProductResponse, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.allProducts = response.products
                    self.state = .success(response.products)
                case .failure(let error):
                    self.state = .failed(error.localizedDescription)
                }
            }
        }
    }
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return allProducts
        } else {
            return allProducts.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
