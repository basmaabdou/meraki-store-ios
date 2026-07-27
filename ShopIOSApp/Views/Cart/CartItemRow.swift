import SwiftUI

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
