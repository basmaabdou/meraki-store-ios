import SwiftUI

struct ProductsListView: View {
    @ObservedObject private var viewModel = ProductsViewModel()
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var selectedCategory: String = "All"

    private var categories: [String] {
        guard case .success(let products) = viewModel.state else { return ["All"] }
        let cats = Set(products.compactMap { $0.category?.capitalized })
        return ["All"] + cats.sorted()
    }

    private var displayedProducts: [Product] {
        viewModel.filteredProducts.filter { product in
            selectedCategory == "All"
                || product.category?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                   == selectedCategory.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    private var gridViewID: AnyHashable {
        displayedProducts.map { $0.id }
    }

    // 💡 تفكيك الحسابات خارج الـ View لمنع الـ Type Checker Timeout
    private var rowCount: Int {
        (displayedProducts.count + 1) / 2
    }

    private func getFirstProduct(for index: Int) -> Product {
        displayedProducts[index * 2]
    }

    private func getSecondProduct(for index: Int) -> Product? {
        let secondIndex = index * 2 + 1
        return secondIndex < displayedProducts.count ? displayedProducts[secondIndex] : nil
    }

    // MARK: - Subviews

    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search products...", text: $viewModel.searchText)
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    self.viewModel.searchText = ""
                    self.selectedCategory = "All"
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var categoryChipsView: some View {
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
    }

    private var productsGridView: some View {
        ScrollView {
            if self.displayedProducts.isEmpty {
                VStack(spacing: 12) {
                    Spacer().frame(height: 40)
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("No products found")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(spacing: 15) {
                    // 💡 أصبحت خفيفة وسريعة جداً بدون أي معادلات أو Ternaries
                    ForEach(0..<rowCount, id: \.self) { index in
                        ProductRowView(
                            firstProduct: self.getFirstProduct(for: index),
                            secondProduct: self.getSecondProduct(for: index)
                        )
                    }
                }
                .padding()
                .id(gridViewID)
            }
        }
    }

    private var successContent: some View {
        VStack(spacing: 0) {
            searchBarView
            categoryChipsView
            productsGridView
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

    private var trailingNavBarItems: AnyView {
        AnyView(HStack(spacing: 16) {
            NavigationLink(destination: FavoritesView(
                products: self.viewModel.allProducts,
                favoritesManager: self.favoritesManager,
                cartManager: self.cartManager
            )
            .environmentObject(self.cartManager)
            .environmentObject(self.favoritesManager)) {
                Image(systemName: "heart")
                    .foregroundColor(.primary)
            }

            NavigationLink(destination: CartView().environmentObject(self.cartManager)) {
                AnyView(
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .font(.body)
                        if self.cartManager.totalItemCount > 0 {
                            Text("\(self.cartManager.totalItemCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 16, height: 16)
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
                .navigationBarTitle("Meraki Store")
                .navigationBarItems(trailing: trailingNavBarItems)
                .onAppear {
                    if case .idle = self.viewModel.state {
                        self.viewModel.fetchProducts()
                    }
                }
        }
    }
}
