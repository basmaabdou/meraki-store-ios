import SwiftUI

struct AsyncImageWrapper: View {
    let urlString: String
    @State private var image: UIImage? = nil
    @State private var didFail: Bool = false
    
    var body: some View {
        contentView
            .onAppear {
                if self.image == nil && !self.didFail {
                    self.loadImage()
                }
            }
    }
    
    private var contentView: AnyView {
        if let img = image {
            return AnyView(
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
            )
        } else if didFail {
            return AnyView(
                ZStack {
                    Color.gray.opacity(0.12)
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            )
        } else {
            return AnyView(
                ZStack {
                    Color.gray.opacity(0.1)
                    ActivityIndicator(isAnimating: true, style: .medium)
                }
            )
        }
    }
    
    private func loadImage() {
         let finalUrlString: String
        if urlString.contains(".webp") {
            finalUrlString = "https://wsrv.nl/?url=\(urlString)&output=png"
        } else {
            finalUrlString = urlString
        }
        
        guard let url = URL(string: finalUrlString) else {
            self.didFail = true
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data,
                  let uiImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.didFail = true
                }
                return
            }
            
            DispatchQueue.main.async {
                self.image = uiImage
            }
        }.resume()
    }
}
