import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var showingCheckoutAlert = false

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
                .foregroundColor(.purple.opacity(0.5))
            Text("Your cart is empty")
                .font(.title2)
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
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(cartManager.totalPrice, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                }
                .padding(.horizontal)

                Button(action: {
                    self.showingCheckoutAlert = true
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "bag.fill")
                        Text("Checkout")
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
                .alert(isPresented: $showingCheckoutAlert) {
                    Alert(
                        title: Text("Checkout"),
                        message: Text("Total: $\(cartManager.totalPrice, specifier: "%.2f")\n\nThank you for your purchase!"),
                        dismissButton: .default(Text("OK")) {
                            self.cartManager.clearCart()
                        }
                    )
                }
            }
            .padding(.vertical, 8)
        }
    }

    var body: some View {
        content
            .navigationBarTitle("Cart (\(cartManager.totalItemCount))", displayMode: .inline)
    }
}

struct CartItemRow: View {
    let item: CartItem
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        HStack(spacing: 12) {
            AsyncImageWrapper(urlString: item.product.thumbnail)
                .frame(width: 70, height: 70)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(2)

                Text("$\(item.product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)

                HStack(spacing: 12) {
                    Button(action: {
                        self.cartManager.updateQuantity(product: self.item.product, newQuantity: self.item.quantity - 1)
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.purple)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Text("\(item.quantity)")
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(minWidth: 24)

                    Button(action: {
                        self.cartManager.updateQuantity(product: self.item.product, newQuantity: self.item.quantity + 1)
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.purple)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }

            Spacer()

            Button(action: {
                self.cartManager.removeFromCart(product: self.item.product)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
    }
}
