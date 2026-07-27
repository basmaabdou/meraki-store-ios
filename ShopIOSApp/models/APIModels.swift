//
//  APIModels.swift
//  ShopIOSApp
//
//  Created by MacBookAir2012 on 6/21/26.
//  Copyright © 2026 MacBookAir2012. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let image: String
    let token: String?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}


// MARK: - Product Model
struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double?
    let rating: Double?
    let stock: Int?
    let brand: String?
    let category: String?
    let thumbnail: String
    let images: [String]?
}

// MARK: - Product Response Wrapper
struct ProductResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}
