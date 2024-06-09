//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol MyNFTPresenterProtocol {
    func viewDidLoad()
    func sortButtonTapped()
    func getNumberOfRows() -> Int
    func getNFT(with indexPath: IndexPath) -> NFTModel
    func isNFTInFav(_ nft: NFTModel) -> Bool
    func addOrRemoveNFTFromFav(nft: NFTModel, isNFTFav: Bool)
    func showOrHidePlaceholder()
    func filterData(_ text: String)
    func sorting(_ sortingAttribute: SortingAttributes)
}

final class MyNFTPresenter: ProfilePresenters {

    // MARK: - ViewController
    weak var view: MyNFTViewProtocol?

    // MARK: - Other properties
    private var arrayOfMyNFT = [NFTModel]()
    private var filteredArrayOfMyNFT = [NFTModel]()
    private var isSearchMode = false

    // MARK: - Private methods
    private func getDataFromStorage() {
        guard let myNFT = storage.myNFT else { print("Ooops1"); return }
        arrayOfMyNFT = myNFT
        filteredArrayOfMyNFT = arrayOfMyNFT
    }

    func showOrHidePlaceholder() {
        if arrayOfMyNFT.isEmpty {
            view?.showPlaceholder()
        } else {
            view?.hideTableView()
        }
    }

    private func addNFTToFav(_ nft: NFTModel) {
        storage.addFavNFTToStorage(nft)
        sendFavsToServer()
    }

    private func removeNFTFromFav(_ nft: NFTModel) {
        storage.removeFavNFTFromStorage(nft)
        sendFavsToServer()
    }

    private func sendFavsToServer() {
        Task { [weak self] in
            guard let self else { return }
            await makeLikes()
            view?.updateTableView()
        }
    }

    private func makeLikes() async {
        let favoriteNFT = storage.profile?.favoriteNFT
        guard let listOfFavs = favoriteNFT else { return }
        do {
            try await network.putLikes(listOfLikes: listOfFavs)
            print("✅ listOfFav successfully updated")
        } catch {
            print(error)
        }
    }
}


// MARK: - MyNFTPresenterProtocol
extension  MyNFTPresenter: MyNFTPresenterProtocol {

    func viewDidLoad() {
        getDataFromStorage()
    }

    func sortButtonTapped() {
        view?.showAlert()
    }

    func getNumberOfRows() -> Int {
        if isSearchMode {
            return filteredArrayOfMyNFT.count
        } else {
            return arrayOfMyNFT.count
        }
    }

    func filterData(_ text: String) {
        if !text.isEmpty {
            isSearchMode = true
            filteredArrayOfMyNFT = arrayOfMyNFT.filter { $0.name?.lowercased().contains(text) ?? false }
        } else {
            isSearchMode = false
        }
    }

    func getNFT(with indexPath: IndexPath) -> NFTModel {
        if isSearchMode {
            return filteredArrayOfMyNFT[indexPath.row]
        } else {
            return arrayOfMyNFT[indexPath.row]
        }
    }

    func isNFTInFav(_ nft: NFTModel) -> Bool {
        guard let listOfFav = storage.profile?.favoriteNFT else { return false }
        if listOfFav.contains(where: { $0 == nft.id }) {
            return true
        } else {
            return false
        }
    }

    func addOrRemoveNFTFromFav(nft: NFTModel, isNFTFav: Bool) {
        if isNFTFav {
            removeNFTFromFav(nft)
        } else {
            addNFTToFav(nft)
        }
    }

    func sorting(_ sortingAttribute: SortingAttributes) {
        var array = isSearchMode ? filteredArrayOfMyNFT : arrayOfMyNFT

        switch sortingAttribute {
        case .name: array.sort { $0.name ?? "" > $1.name ?? "" }
        case .price: array.sort { $0.price ?? 0.0 > $1.price ?? 0.0 }
        case .rating: array.sort { $0.rating ?? 0 > $1.rating ?? 0 }
        }

        if isSearchMode {
            filteredArrayOfMyNFT = array
        } else {
            arrayOfMyNFT = array
        }

        view?.updateTableView()
    }
}

