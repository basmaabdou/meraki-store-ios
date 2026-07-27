//
//  ContentView.swift
//  ShopIOSApp
//
//  Created by MacBookAir2012 on 6/28/26.
//  Copyright © 2026 MacBookAir2012. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // استخدام @ObservedObject بدلاً من @StateObject ليتوافق مع iOS 13
    @ObservedObject private var authViewModel = AuthViewModel()
    
    // استخراج المنطق عبر AnyView لحل مشكلة الـ ViewBuilder والتحكم بالتدفق
    private var rootContentView: AnyView {
        if case .success = authViewModel.state {
            return AnyView(ProductsListView())
        } else {
            return AnyView(LoginView(viewModel: authViewModel))
        }
    }
    
    var body: some View {
        rootContentView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
