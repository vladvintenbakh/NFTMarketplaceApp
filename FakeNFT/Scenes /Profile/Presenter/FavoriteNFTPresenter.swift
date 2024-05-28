//
//  FavoriteNFTPresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol FavoriteNFTPresenterProtocol {
    func getNumberOfRows() -> Int
    func removeNFTFromFav(_ nft: NFTModel)
    func uploadDataFromStorage()
    func showOrHidePlaceholder()
    func getArrayOfFav() -> [NFTModel]
}

final class FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {

    // MARK: - ViewController
    weak var view: FavoriteNFTViewProtocol?

    // MARK: - Other properties
    var mockArrayOfNFT = [NFTModel]()

    // MARK: - Init
    init(view: FavoriteNFTViewProtocol?) {
        self.view = view
        self.uploadDataFromStorage()
    }

    // MARK: - Public methods
    func getArrayOfFav() -> [NFTModel] {
        mockArrayOfNFT
    }

    func showOrHidePlaceholder() {
        if mockArrayOfNFT.isEmpty {
            view?.showPlaceholder()
        } else {
            view?.hideCollection()
        }
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

        view?.updateUI()
    }
}
