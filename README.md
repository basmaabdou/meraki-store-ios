Meraki Store – iOS

A native iOS e-commerce app built with SwiftUI while learning iOS development.

<!-- ## Screenshots <p float="left"> <img src="screenshots/login.png" width="200" /> <img src="screenshots/products.png" width="200" /> <img src="screenshots/cart.png" width="200" /> </p> -->
Features
Splash screen and login
Products list with product details
Cart: add, remove and update quantity, then checkout
Favorites
Login token stored securely in the Keychain
Image loading wrapper and activity indicator
Architecture

MVVM: Views / ViewModels / Models, with Managers for cart, favorites and networking.

Tech Stack
Swift, SwiftUI
Networking: URLSession with Decodable JSON parsing (DummyJSON API)
Security: Keychain
Run the project

Open ShopIOSApp.xcodeproj in Xcode and run on a simulator.
