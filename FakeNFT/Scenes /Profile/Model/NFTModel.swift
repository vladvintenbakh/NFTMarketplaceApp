//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 27.05.2024.
//

import Foundation

// MARK: - NFTMockDataModel
struct NFTModel: Codable {
    var imageName: String?
    var name: String?
    var rating: Int?
    var author: String?
    var price: String?
}
