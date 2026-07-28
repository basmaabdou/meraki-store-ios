import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var showAlert = false
    @State private var errorMessage = ""
    @State private var isPasswordVisible = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)

                        VStack(spacing: 25) {
                            // Brand Header
                            VStack(spacing: 10) {
                                Image(systemName: "bag.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.purple)

                                Text("VibeMarket")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)

                                Text("Sign in to start shopping")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            // Input Fields
                            VStack(spacing: 15) {
                                HStack(spacing: 12) {
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(.purple)
                                        .frame(width: 20)
                                    TextField("Email", text: self.$viewModel.email)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .keyboardType(.emailAddress)
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)

                                HStack(spacing: 12) {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.purple)
                                        .frame(width: 20)
                                    if self.isPasswordVisible {
                                        TextField("Password", text: self.$viewModel.password)
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                    } else {
                                        SecureField("Password", text: self.$viewModel.password)
                                    }
                                    Button(action: {
                                        self.isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: self.isPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundColor(.gray)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)

                            // Submit Button
                            Button(action: {
                                self.dismissKeyboard()
                                self.viewModel.login()
                            }) {
                                self.buttonContentView
                            }
                            .padding(.horizontal)
                            .disabled(self.viewModel.email.isEmpty || self.viewModel.password.isEmpty)
                        }
                        .frame(maxWidth: 340)
                        .padding(.horizontal)

                        Spacer(minLength: 0)
                    }
                    .frame(minHeight: geometry.size.height)
                    .frame(maxWidth: .infinity)
                }
                .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
                .onTapGesture {
                    self.dismissKeyboard()
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .onReceive(self.viewModel.$state) { newState in
                    if case .failed(let message) = newState {
                        self.errorMessage = message
                        self.showAlert = true
                    }
                }
                .alert(isPresented: self.$showAlert) { () -> Alert in
                    Alert(
                        title: Text("Error"),
                        message: Text(self.errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private var buttonContentView: AnyView {
        if case .loading = self.viewModel.state {
            return AnyView(
                HStack {
                    Spacer()
                    ActivityIndicator(isAnimating: true, style: .medium)
                    Spacer()
                }
                .padding()
                .background(Color.purple)
                .cornerRadius(12)
            )
        } else {
            return AnyView(
                HStack {
                    Spacer()
                    Text("Log In")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color.purple)
                .cornerRadius(12)
            )
        }
    }
}
