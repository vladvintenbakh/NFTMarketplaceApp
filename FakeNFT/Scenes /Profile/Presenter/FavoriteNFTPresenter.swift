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

final class FavoriteNFTPresenter: ProfilePresenters {

    // MARK: - ViewController
    weak var view: FavoriteNFTViewProtocol?

    // MARK: - Private properties
    private var arrayOfFavNFT = [NFTModel]()

    // MARK: - Life cycle
    func viewDidLoad() {
        getArrayOfFavFromStorage()
    }

    // MARK: - Private methods
    private func getArrayOfFavFromStorage() {
        guard let arrayOfFavNFTFromStorage = storage.favNFT else { return }
        arrayOfFavNFT = arrayOfFavNFTFromStorage
    }

    private func updateView() {
        view?.updateUI()
        showOrHidePlaceholder()
    }

    private func showOrHidePlaceholder() {
        if arrayOfFavNFT.isEmpty {
            view?.showPlaceholder()
        } else {
            view?.hideCollection()
        }
    }
}

// MARK: - FavoriteNFTPresenterProtocol
extension FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {

    func getFavNFT(indexPath: IndexPath) -> NFTModel {
        return arrayOfFavNFT[indexPath.row]
    }

    func getNumberOfRows() -> Int {
        return arrayOfFavNFT.count
    }

    func removeNFTFromFav(_ nft: NFTModel) {
        storage.removeFavNFTFromStorage(nft)
        getArrayOfFavFromStorage()
        sendFavsToServer()
    }

    private func sendFavsToServer() {
        Task {
            await makeLikes()
            updateView()
        }
    }

    private func makeLikes() async {
        guard let favoriteNFT = storage.profile?.favoriteNFT else { return }
        do {
            try await network.putLikes(listOfLikes: favoriteNFT)
            print("✅ listOfFav successfully updated")
        } catch {
            print(error)
        }
    }
}
