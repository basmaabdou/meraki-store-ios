import SwiftUI

struct ProductRowView: View {
    let firstProduct: Product
    let secondProduct: Product?
    
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        HStack(spacing: 15) {
            NavigationLink(destination: ProductDetailView(product: self.firstProduct, cartManager: self.cartManager)) {
                ProductCardView(product: self.firstProduct)
            }
            .buttonStyle(PlainButtonStyle())

            Group {
                if self.secondProduct != nil {
                    NavigationLink(destination: ProductDetailView(product: self.secondProduct!, cartManager: self.cartManager)) {
                        ProductCardView(product: self.secondProduct!)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Spacer()
                }
            }
        }
    }
}
