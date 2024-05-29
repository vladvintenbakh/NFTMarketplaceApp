//
//  FavoriteNFTPresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol FavoriteNFTPresenterProtocol {
    func viewDidLoad()
    func getNumberOfRows() -> Int
    func removeNFTFromFav(_ nft: NFTModel)
    func getFavNFT(indexPath: IndexPath) -> NFTModel
}

final class FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {

    // MARK: - ViewController
    weak var view: FavoriteNFTViewProtocol?

    // MARK: - Other properties
    var mockArrayOfNFT = [NFTModel]()


    // MARK: - Public methods
    func viewDidLoad() {
        uploadDataFromStorage()
        showOrHidePlaceholder()
    }

    func getFavNFT(indexPath: IndexPath) -> NFTModel {
        return mockArrayOfNFT[indexPath.row]
    }


    func getNumberOfRows() -> Int {
        return mockArrayOfNFT.count
    }

    func removeNFTFromFav(_ nft: NFTModel) {
        let storage = MockDataStorage()
        let nftToRemoveFromFav = nft
        storage.removeFromFavNFT(nftToRemoveFromFav)

        uploadDataFromStorage()

        view?.updateUI()
    }

    // MARK: - Private methods
    private func showOrHidePlaceholder() {
        if mockArrayOfNFT.isEmpty {
            view?.showPlaceholder()
        } else {
            view?.hideCollection()
        }
    }

    private func uploadDataFromStorage() {
        let data = MockDataStorage.mockData
        guard let favoriteNFT = data.favoriteNFT else { print("Jopa"); return }
        mockArrayOfNFT = favoriteNFT
    }
}
