import SwiftUI

struct ContentView: View {
    @ObservedObject private var authViewModel = AuthViewModel()
    
    private var rootContentView: AnyView {
        if case .success = authViewModel.state {
            return AnyView(ProductsListView())
        } else {
            return AnyView(LoginView(viewModel: authViewModel))
        }
    }
    
    var body: some View {
        rootContentView
    }
}
