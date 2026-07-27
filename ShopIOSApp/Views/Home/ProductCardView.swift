import SwiftUI

struct ProductCardView: View {
    let product: Product
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AsyncImageWrapper(urlString: product.thumbnail)
                    .frame(height: 140)
                    .clipped()
                    .cornerRadius(10)

                Button(action: {
                    self.favoritesManager.toggleFavorite(self.product.id)
                }) {
                    Image(systemName: favoritesManager.isFavorite(product.id) ? "heart.fill" : "heart")
                        .foregroundColor(favoritesManager.isFavorite(product.id) ? .red : .white)
                        .padding(6)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .padding(6)
            }

            Text(product.title)
                .font(.headline)
                .lineLimit(1)

            Text(product.category?.capitalized ?? "General")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)

                Spacer()

                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", product.rating ?? 0.0))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
