import SwiftUI

struct ContentView: View {
    @ObservedObject private var authViewModel = AuthViewModel()
    @State private var isShowingSplash = true
    @State private var logoOpacity = 0.3

    private var rootContentView: AnyView {
        if isShowingSplash {
            return AnyView(splashView)
        } else if case .success = authViewModel.state {
            return AnyView(ProductsListView())
        } else {
            return AnyView(LoginView(viewModel: authViewModel))
        }
    }

    // MARK: - Splash View
    private var splashView: some View {
        return ZStack {
            Color(red: 245/255, green: 243/255, blue: 238/255)
                .edgesIgnoringSafeArea(.all)

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 190, height: 190)
                .opacity(logoOpacity)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) {
                self.logoOpacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    self.isShowingSplash = false
                }
            }
        }
    }

    var body: some View {
        rootContentView
    }
}
