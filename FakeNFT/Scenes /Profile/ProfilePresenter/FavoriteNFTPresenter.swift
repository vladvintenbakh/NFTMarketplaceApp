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
    func filterData(_ text: String)
}

final class FavoriteNFTPresenter: ProfilePresenters {

    // MARK: - ViewController
    weak var view: FavoriteNFTViewProtocol?

    // MARK: - Private properties
    private var arrayOfFavNFT = [NFTModel]()
    private var filteredArrayOfFavNFT = [NFTModel]()
    private var isSearchMode = false

    // MARK: - Life cycle
    func viewDidLoad() {
        getArrayOfFavFromStorage()
    }

    // MARK: - Private methods
    private func getArrayOfFavFromStorage() {
        guard let arrayOfFavNFTFromStorage = storage.favNFT else { return }
        arrayOfFavNFT = arrayOfFavNFTFromStorage
        filteredArrayOfFavNFT = arrayOfFavNFT
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
        if isSearchMode {
            return filteredArrayOfFavNFT[indexPath.row]
        } else {
            return arrayOfFavNFT[indexPath.row]
        }
    }

    func filterData(_ text: String) {
        isSearchMode = true
        if !text.isEmpty {
            filteredArrayOfFavNFT = arrayOfFavNFT.filter { $0.name?.lowercased().contains(text) ?? false }
        } else {
            filteredArrayOfFavNFT = arrayOfFavNFT
        }
    }

    func getNumberOfRows() -> Int {
        if isSearchMode {
            return filteredArrayOfFavNFT.count
        } else {
            return arrayOfFavNFT.count
        }
    }

    func removeNFTFromFav(_ nft: NFTModel) {
        storage.removeFavNFTFromStorage(nft)
        getArrayOfFavFromStorage()
        sendFavsToServer()
    }

    private func sendFavsToServer() {
        Task { [weak self] in
            guard let self else { return }
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
