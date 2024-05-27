//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 27.05.2024.
//

import Foundation

// MARK: - ProfileMockModel
struct ProfileModel: Codable {
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]?
    let favoriteNFT: [String]?
    let id: String?
}
