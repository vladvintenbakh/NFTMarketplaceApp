//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 27.05.2024.
//

import Foundation

// MARK: - NFTMockDataModel
struct NFTModel: Codable {
    let imageName: String?
    let name: String?
    let rating: Int?
    let author: String?
    let price: String?
}
