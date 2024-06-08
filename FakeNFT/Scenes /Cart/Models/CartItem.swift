//
//  CartItem.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 25/5/24.
//

import Foundation

struct CartItem: Codable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
}
