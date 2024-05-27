//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

// MARK: - ProfileMockData
struct ProfileModel: Codable {
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]?
    let favoriteNFT: [String]?
    let id: String?
}

protocol ProfilePresenterProtocol {
    var mockData: ProfileModel { get }

}

final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileMainVC?

    var mockData = ProfileModel(name: "Joaquin Phoenix",
                                avatar: "phoenix",
                                description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                                website: "https://www.ivi.tv/person/hoakin_feniks",
                                nfts: ["1", "2", "3"],
                                favoriteNFT: [],
                                id: "123123123")


}
