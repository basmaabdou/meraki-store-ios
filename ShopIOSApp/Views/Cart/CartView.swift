import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var showingClearAlert = false

    private var content: AnyView {
        if cartManager.items.isEmpty {
            return AnyView(emptyStateView)
        } else {
            return AnyView(cartContent)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "cart.fill")
            .font(.system(size: 70))
            .foregroundColor(Color.purple.opacity(0.5))
            Text("Your cart is empty")
                .font(.title)
                .fontWeight(.semibold)
            Text("Browse products and add items to your cart")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }

    private var cartContent: some View {
        VStack(spacing: 0) {
            List {
                ForEach(cartManager.items) { item in
                    CartItemRow(item: item)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let item = self.cartManager.items[index]
                        self.cartManager.removeFromCart(product: item.product)
                    }
                }
            }
            .listStyle(PlainListStyle())

            VStack(spacing: 12) {
                Divider()

                HStack {
                    Text("Subtotal")
                        .font(.body)
                    Spacer()
                    Text("$\(cartManager.subtotal, specifier: "%.2f")")
                        .font(.body)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)

                HStack {
                    Text("Shipping Fee")
                        .font(.body)
                    Spacer()
                    Text("$\(cartManager.shippingFee, specifier: "%.2f")")
                        .font(.body)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)

                HStack {
                    Text("Tax (8%)")
                        .font(.body)
                    Spacer()
                    Text("$\(cartManager.tax, specifier: "%.2f")")
                        .font(.body)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)

                Divider()

                HStack {
                    Text("Total")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(cartManager.totalPrice, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                }
                .padding(.horizontal)

                NavigationLink(destination: CheckoutView()) {
                    HStack {
                        Spacer()
                        Image(systemName: "bag.fill")
                        Text("Proceed to Checkout")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.vertical, 8)
        }
    }

    var body: some View {
        content
            .navigationBarTitle("Cart (\(cartManager.totalItemCount))", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingClearAlert = true
                }) {
                    Text("Clear")
                        .foregroundColor(.red)
                }
            )
            .alert(isPresented: $showingClearAlert) {
                Alert(
                    title: Text("Clear Cart"),
                    message: Text("Remove all items from your cart?"),
                    primaryButton: .destructive(Text("Clear")) {
                        self.cartManager.clearCart()
                    },
                    secondaryButton: .cancel()
                )
            }
    }
}
