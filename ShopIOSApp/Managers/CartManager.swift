import Foundation

class CartManager: ObservableObject {
    @Published var items: [CartItem] = []

    let shippingFee: Double = 15.0

    var subtotal: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    var tax: Double {
        subtotal * 0.08
    }

    var totalPrice: Double {
        subtotal + tax + shippingFee
    }

    var totalItemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    func addToCart(product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
    }

    func removeFromCart(product: Product) {
        items.removeAll { $0.product.id == product.id }
    }

    func updateQuantity(product: Product, newQuantity: Int) {
        guard let index = items.firstIndex(where: { $0.product.id == product.id }) else { return }
        if newQuantity <= 0 {
            items.remove(at: index)
        } else {
            items[index].quantity = newQuantity
        }
    }

    func clearCart() {
        items.removeAll()
    }
}

struct CartItem: Identifiable {
    let id: Int
    let product: Product
    var quantity: Int

    init(product: Product, quantity: Int) {
        self.id = product.id
        self.product = product
        self.quantity = quantity
    }
}
