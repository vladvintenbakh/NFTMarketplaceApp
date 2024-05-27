//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 27.05.2024.
//

import Foundation

// MARK: - ProfileMockModel
struct ProfileMockModel: Codable {
    var name: String?
    let avatar: String?
    var description: String?
    var website: String?
    let nfts: [NFTModel]?
    let favoriteNFT: [NFTModel]?
    let id: String?
}
