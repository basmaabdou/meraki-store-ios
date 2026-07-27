import SwiftUI

struct ProductsListView: View {
    @ObservedObject private var viewModel = ProductsViewModel()
    @EnvironmentObject var cartManager: CartManager
    // استخراج switch خارج body وتغليف الناتج بـ AnyView لحل قيود Xcode 11/SwiftUI 1.0
    private var stateContentView: AnyView {
        switch viewModel.state {
        case .idle, .loading:
            return AnyView(
                VStack(spacing: 15) {
                    ActivityIndicator(isAnimating: true, style: .large)
                    Text("جاري تحميل المنتجات...")
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
                    Button("إعادة المحاولة") {
                        // التعديل هنا: إضافة self. الصريحة للـ Closure
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
            return AnyView(
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(0..<(self.viewModel.filteredProducts.count + 1) / 2, id: \.self) { index in
                            ProductRowView(
                                firstProduct: self.viewModel.filteredProducts[index * 2],
                                secondProduct: (index * 2 + 1 < self.viewModel.filteredProducts.count) ? self.viewModel.filteredProducts[index * 2 + 1] : nil
                            )
                        }
                    }
                    .padding()
                }
            )
        }
    }
    
    var body: some View {
        NavigationView {
            stateContentView
                .navigationBarTitle("AuraShop 🛍️")
                .onAppear {
                    if case .idle = self.viewModel.state {
                        self.viewModel.fetchProducts()
                    }
                }
        }
    }
}


struct ProductRowView: View {
    let firstProduct: Product
    let secondProduct: Product?
    @EnvironmentObject var cartManager: CartManager
    
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

// MARK: - بطاقة المنتج المنفصلة (ProductCardView)
struct ProductCardView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImageWrapper(urlString: product.thumbnail)
                .frame(height: 140)
                .clipped()
                .cornerRadius(10)
            
            Text(product.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(product.category?.capitalized ?? "عام")
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
