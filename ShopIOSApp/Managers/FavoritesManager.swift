import Foundation

class FavoritesManager: ObservableObject {
    @Published var favoriteProductIds: Set<Int> = []

    func isFavorite(_ productId: Int) -> Bool {
        favoriteProductIds.contains(productId)
    }

    func toggleFavorite(_ productId: Int) {
        if favoriteProductIds.contains(productId) {
            favoriteProductIds.remove(productId)
        } else {
            favoriteProductIds.insert(productId)
        }
    }
}
