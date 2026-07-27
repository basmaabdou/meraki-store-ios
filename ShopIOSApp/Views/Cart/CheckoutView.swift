import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    @State private var fullName = ""
    @State private var address = ""
    @State private var phoneNumber = ""
    @State private var orderPlaced = false
    @State private var showingValidationAlert = false

    private var content: AnyView {
        if orderPlaced {
            return AnyView(orderSuccessView)
        } else {
            return AnyView(checkoutForm)
        }
    }

    private var checkoutForm: some View {
        Form {
            Section(header: Text("Customer Details")) {
                TextField("Full Name", text: $fullName)
                TextField("Address", text: $address)
                TextField("Phone Number", text: $phoneNumber)
                    .keyboardType(.phonePad)
            }

            Section(header: Text("Order Summary")) {
                HStack {
                    Text("Subtotal")
                    Spacer()
                    Text("$\(cartManager.subtotal, specifier: "%.2f")")
                }

                HStack {
                    Text("Shipping Fee")
                    Spacer()
                    Text("$\(cartManager.shippingFee, specifier: "%.2f")")
                }

                HStack {
                    Text("Total")
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(cartManager.totalPrice, specifier: "%.2f")")
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                }
            }

            Section {
                Button(action: {
                    if self.fullName.isEmpty || self.address.isEmpty || self.phoneNumber.isEmpty {
                        self.showingValidationAlert = true
                    } else {
                        self.cartManager.clearCart()
                        self.orderPlaced = true
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Place Order")
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
            }
        }
        .navigationBarTitle("Checkout", displayMode: .inline)
        .alert(isPresented: $showingValidationAlert) {
            Alert(
                title: Text("Missing Information"),
                message: Text("Please fill in all customer details."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private var orderSuccessView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)

            Text("Order Placed!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Thank you for your purchase.")
                .font(.body)
                .foregroundColor(.secondary)

            Spacer()

            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text("Continue Shopping")
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
        .navigationBarTitle("Success", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }

    var body: some View {
        content
    }
}
