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

final class FavoriteNFTPresenter {

    // MARK: - ViewController
    weak var view: FavoriteNFTViewProtocol?

    // MARK: - Private properties
    private var mockArrayOfNFT = [NFTModel]()

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

// MARK: - FavoriteNFTPresenterProtocol
extension FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {

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

}
