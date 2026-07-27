import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @ObservedObject var cartManager: CartManager // 👈 نستخدم ObservedObject لضمان استقرار الربط عند التمرير المباشر
    @State private var quantity = 1
    @State private var showAddedAlert = false
    @State private var addedQuantity = 0
    @State private var showCart = false

    // Initializer صريح يمنع خطأ Compilation تماماً
    init(product: Product, cartManager: CartManager) {
        self.product = product
        self.cartManager = cartManager
    }

    private var cartBarButton: AnyView {
        AnyView(
            ZStack {
                NavigationLink(
                    destination: CartView().environmentObject(self.cartManager),
                    isActive: $showCart
                ) {
                    EmptyView()
                }
                .hidden()

                Button(action: {
                    self.showCart = true
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .font(.body)
                        if cartManager.totalItemCount > 0 {
                            Text("\(cartManager.totalItemCount)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 10, y: -10)
                        }
                    }
                }
            }
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImageWrapper(urlString: product.thumbnail)
                    .frame(height: 280)
                    .cornerRadius(16)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(product.brand ?? product.category?.capitalized ?? "عام")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.purple.opacity(0.15))
                            .foregroundColor(.purple)
                            .cornerRadius(6)

                        Spacer()

                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", product.rating ?? 0.0))
                                .fontWeight(.bold)
                        }
                    }
                    
                    Text(product.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)

                    Divider()

                    Text("Info about product :")
                        .font(.headline)

                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                }
                .padding(.horizontal)

                Divider()
                    .padding(.horizontal)

                HStack {
                    Text("Quantity:")
                        .font(.headline)
                    Spacer()
                    HStack(spacing: 16) {
                        Button(action: {
                            if self.quantity > 1 { self.quantity -= 1 }
                        }) {
                            Image(systemName: "minus.circle")
                                .font(.title)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Text("\(quantity)")
                            .font(.title)
                            .fontWeight(.semibold)
                            .frame(minWidth: 32)

                        Button(action: {
                            self.quantity += 1
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button(action: {
                    let qty = self.quantity
                    self.cartManager.addToCart(product: self.product, quantity: qty)
                    self.addedQuantity = qty
                    self.showAddedAlert = true
                    self.quantity = 1
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "cart.badge.plus")
                        Text("Add to Cart")
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
                .alert(isPresented: $showAddedAlert) {
                    Alert(
                        title: Text("Added to Cart"),
                        message: Text("\(product.title) x\(addedQuantity) added to your cart."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        .navigationBarTitle(Text(product.title), displayMode: .inline)
        .navigationBarItems(trailing: cartBarButton)
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(
            product: Product(
                id: 1,
                title: "Sample",
                description: "Sample desc",
                price: 9.99,
                discountPercentage: 0,
                rating: 4.5,
                stock: 10,
                brand: "Brand",
                category: "Category",
                thumbnail: "",
                images: []
            ),
            cartManager: CartManager() // 👈 مرري CartManager() هنا أيضاً
        )
    }
}
