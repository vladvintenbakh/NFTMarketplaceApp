//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 27.05.2024.
//

import Foundation

// MARK: - NFTDataModel
struct NFTModel: Codable {
    var name: String?
    var images: [String]?
    var rating: Int?
    var author: String?
    var price: Double?
}


//struct Welcome: Codable {
//    let createdAt, name: String?
//    let images: [String]?
//    let rating: Int?
//    let description: String?
//    
//    let price: Double?
//    let author: String?
//    let id: String?
//}
