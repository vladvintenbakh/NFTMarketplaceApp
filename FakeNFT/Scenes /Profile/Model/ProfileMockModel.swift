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
    var favoriteNFT: [NFTModel]?
    let id: String?
}


// MARK: - ProfileModel
struct ProfileModel: Codable {
    var name: String?
    var avatar: String?
    var description: String?
    var website: String?
    let nfts: [String]?
    var favoriteNFT: [String]?
    let id: String?

    init(name: String?, avatar: String?, description: String?, website: String?, nfts: [String]?, favoriteNFT: [String]?, id: String?) {
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.nfts = nfts
        self.favoriteNFT = favoriteNFT
        self.id = id
    }

    init(from data: ApiModel) {
        self.name = data.name
        self.avatar = data.avatar
        self.description = data.description
        self.website = data.website
        self.nfts = data.nfts
        self.favoriteNFT = data.likes
        self.id = data.id
    }
}

