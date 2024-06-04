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
    func priceSorting()
    func ratingSorting()
    func nameSorting()
    func addOrRemoveNFTFromFav(nft: NFTModel, isNFTFav: Bool)
    func showOrHidePlaceholder()
}

final class MyNFTPresenter: ProfilePresenters {

    // MARK: - ViewController
    weak var view: MyNFTViewProtocol?

    // MARK: - Other properties
    private var arrayOfMyNFT = [NFTModel]()

    // MARK: - Private methods
    private func getDataFromStorage() {
        guard let myNFT = storage.myNFT else { print("Ooops1"); return }
        arrayOfMyNFT = myNFT
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
        return arrayOfMyNFT.count
    }

    func getNFT(with indexPath: IndexPath) -> NFTModel {
        return arrayOfMyNFT[indexPath.row]
    }

    func priceSorting() {
        arrayOfMyNFT.sort {
            guard let price1 = $0.price,
                  let price2 = $1.price else { print("Sorting problem"); return false }
            return price1 > price2
        }
        view?.updateTableView()
    }

    func ratingSorting() {
        arrayOfMyNFT.sort {
            guard let rating1 = $0.rating,
                  let rating2 = $1.rating else { print("Sorting problem"); return false}
            return rating1 > rating2
        }
        view?.updateTableView()
    }

    func nameSorting() {
        arrayOfMyNFT.sort {
            guard let rating1 = $0.name,
                  let rating2 = $1.name else { print("Sorting problem"); return false}
            return rating1 > rating2
        }
        view?.updateTableView()
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
}
