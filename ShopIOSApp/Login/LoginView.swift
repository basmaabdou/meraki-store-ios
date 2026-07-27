import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var showAlert = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 25) {
                        // Header Section
                        VStack(spacing: 10) {
                            Image(systemName: "bag.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.purple)

                            Text("AuraShop")
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Text("سجّلي الدخول للبدء بالتسوق")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 40)

                        // Input Fields
                        VStack(spacing: 15) {
                            TextField("اسم المستخدم (مثل: kminchelle)", text: self.$viewModel.username)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)

                            SecureField("كلمة المرور (مثل: 0lelpassword)", text: self.$viewModel.password)
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
                        .disabled(self.viewModel.username.isEmpty || self.viewModel.password.isEmpty)
                        
                        Spacer()
                    }
                    .frame(minHeight: geometry.size.height) // ملء ارتفاع الشاشة بالكامل
                }
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            // إغلاق الكيبورد عند الضغط على أي مكان فارغ بالشاشة
            .onTapGesture {
                self.dismissKeyboard()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .onReceive(viewModel.$state) { newState in
                if case .failed(let message) = newState {
                    self.errorMessage = message
                    self.showAlert = true
                }
            }
            .alert(isPresented: $showAlert) { () -> Alert in
                Alert(
                    title: Text("خطأ"),
                    message: Text(self.errorMessage),
                    dismissButton: .default(Text("حسناً"))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // إغلاق لوحة المفاتيح برمجياً في iOS 13
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // استخراج واجهة الزر لتجنب أخطاء ViewBuilder في iOS 13
    private var buttonContentView: AnyView {
        if case .loading = viewModel.state {
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
                    Text("تسجيل الدخول")
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

// MARK: - مكون ActivityIndicator للتوافق مع iOS 13
struct ActivityIndicator: UIViewRepresentable {
    let isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = .white
        return indicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
