import SwiftUI

struct ProductDetailView: View {
    let product: Product
    
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
                
                Spacer()
               
                Button(action: {}) {
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
            }
        }
        .navigationBarTitle(Text(product.title), displayMode: .inline)
    }
}
