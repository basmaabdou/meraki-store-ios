import SwiftUI

struct FavoritesView: View {
    let products: [Product]
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var cartManager: CartManager

    private var favoriteProducts: [Product] {
        products.filter { favoritesManager.isFavorite($0.id) }
    }

    var body: some View {
        Group {
            if favoriteProducts.isEmpty {
                emptyStateView
            } else {
                productGrid
            }
        }
        .navigationBarTitle("Favorites", displayMode: .inline)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "heart.slash")
                .font(.system(size: 70))
                .foregroundColor(Color.gray.opacity(0.5))
            Text("No favorites yet")
                .font(.system(size: 22, weight: .semibold))
            Text("Tap the heart icon on products to add them here")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }

    private var productGrid: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(0..<(self.favoriteProducts.count + 1) / 2, id: \.self) { index in
                    ProductRowView(
                        firstProduct: self.favoriteProducts[index * 2],
                        secondProduct: (index * 2 + 1 < self.favoriteProducts.count) ? self.favoriteProducts[index * 2 + 1] : nil
                    )
                }
            }
            .padding()
        }
    }
}
