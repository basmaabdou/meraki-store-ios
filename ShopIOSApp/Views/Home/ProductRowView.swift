import SwiftUI

struct ProductRowView: View {
    let firstProduct: Product
    let secondProduct: Product?
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        HStack(spacing: 15) {
            NavigationLink(destination: ProductDetailView(product: firstProduct, cartManager: self.cartManager)) {
                ProductCardView(product: firstProduct)
            }
            .buttonStyle(PlainButtonStyle())

            Group {
                if secondProduct != nil {
                    NavigationLink(destination: ProductDetailView(product: secondProduct!, cartManager: self.cartManager)) {
                        ProductCardView(product: secondProduct!)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Spacer()
                }
            }
        }
    }
}
