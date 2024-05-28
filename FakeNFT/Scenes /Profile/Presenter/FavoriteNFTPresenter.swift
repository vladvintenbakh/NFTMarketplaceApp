//
//  FavoriteNFTPresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol FavoriteNFTPresenterProtocol {
    var mockArrayOfNFT: [NFTModel] { get }

    func getNumberOfRows() -> Int
    func removeNFTFromFav(_ nft: NFTModel)
    func uploadDataFromStorage()
}

final class FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {

    weak var view: FavoriteNFTViewProtocol?

    var mockArrayOfNFT = [NFTModel]()

    init(view: FavoriteNFTViewProtocol?) {
        self.view = view
        self.uploadDataFromStorage()
    }

    func getNumberOfRows() -> Int {
        return mockArrayOfNFT.count
    }

    func uploadDataFromStorage() {
        let data = MockDataStorage.mockData
        guard let favoriteNFT = data.favoriteNFT else { print("Jopa"); return }
        mockArrayOfNFT = favoriteNFT
    }

    func removeNFTFromFav(_ nft: NFTModel) {
        let storage = MockDataStorage()
        let nftToRemoveFromFav = nft
        storage.removeFromFavNFT(nftToRemoveFromFav)
    }
}
