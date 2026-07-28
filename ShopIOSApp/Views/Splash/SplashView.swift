import SwiftUI

struct SplashView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var isActive = false
    @State private var opacity = 0.5

    var body: some View {
        if isActive {
            // تمرير viewModel المفقود
            return AnyView(LoginView(viewModel: authViewModel))
        } else {
            return AnyView(
                ZStack {
                    Color(red: 245/255, green: 243/255, blue: 238/255)
                        .edgesIgnoringSafeArea(.all)

                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .opacity(opacity)
                }
                .onAppear {
                    withAnimation(.easeIn(duration: 0.8)) {
                        self.opacity = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            )
        }
    }
}
