import SwiftUI

struct ProductsListView: View {
    @ObservedObject private var viewModel = ProductsViewModel()
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var showFavoritesOnly = false
    @State private var selectedCategory: String = "All"

    private var categories: [String] {
        guard case .success(let products) = viewModel.state else { return ["All"] }
        let cats = Set(products.compactMap { $0.category?.capitalized })
        return ["All"] + cats.sorted()
    }

    private var displayedProducts: [Product] {
        viewModel.filteredProducts.filter { product in
            let catMatch = self.selectedCategory == "All" || product.category?.capitalized == self.selectedCategory
            let favMatch = !self.showFavoritesOnly || self.favoritesManager.isFavorite(product.id)
            return catMatch && favMatch
        }
    }

    private var stateContentView: AnyView {
        switch viewModel.state {
        case .idle, .loading:
            return AnyView(
                VStack(spacing: 15) {
                    ActivityIndicator(isAnimating: true, style: .large)
                    Text("Loading products...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            )

        case .failed(let message):
            return AnyView(
                VStack(spacing: 15) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    Text(message)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Retry") {
                        self.viewModel.fetchProducts()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            )

        case .success:
            return AnyView(successContent)
        }
    }

    private var successContent: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search products...", text: $viewModel.searchText)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 8)

            // Category chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            self.selectedCategory = category
                        }) {
                            Text(category)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(self.selectedCategory == category ? Color.purple : Color(.systemGray5))
                                .foregroundColor(self.selectedCategory == category ? .white : .primary)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)

            // Product grid
            ScrollView {
                if self.displayedProducts.isEmpty {
                    AnyView(
                        VStack(spacing: 12) {
                            Spacer().frame(height: 40)
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No products found")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                    )
                } else {
                    AnyView(
                        VStack(spacing: 15) {
                            ForEach(0..<(self.displayedProducts.count + 1) / 2, id: \.self) { index in
                                ProductRowView(
                                    firstProduct: self.displayedProducts[index * 2],
                                    secondProduct: (index * 2 + 1 < self.displayedProducts.count) ? self.displayedProducts[index * 2 + 1] : nil
                                )
                            }
                        }
                        .padding()
                    )
                }
            }
        }
    }

    private var trailingNavBarItems: AnyView {
        AnyView(HStack(spacing: 16) {
            Button(action: {
                self.showFavoritesOnly.toggle()
            }) {
                Image(systemName: self.showFavoritesOnly ? "heart.fill" : "heart")
                    .foregroundColor(self.showFavoritesOnly ? .red : .primary)
            }

            NavigationLink(destination: CartView().environmentObject(self.cartManager)) {
                AnyView(
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .font(.body)
                        if self.cartManager.totalItemCount > 0 {
                            Text("\(self.cartManager.totalItemCount)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 18, height: 18)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 8, y: -8)
                        }
                    }
                )
            }
        })
    }

    var body: some View {
        NavigationView {
            stateContentView
                .navigationBarTitle("AuraShop")
                .navigationBarItems(trailing: trailingNavBarItems)
                .onAppear {
                    if case .idle = self.viewModel.state {
                        self.viewModel.fetchProducts()
                    }
                }
        }
    }
}
