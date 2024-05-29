//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol MyNFTPresenterProtocol {
    func getNumberOfRows() -> Int
    func getNFT(with indexPath: IndexPath) -> NFTModel
    func isNFTInFav(_ nft: NFTModel) -> Bool
    func priceSorting()
    func ratingSorting()
    func nameSorting()
    func sortButtonTapped()
    func viewDidLoad()
    func addOrRemoveNFTFromFav(nft: NFTModel, isNFTFav: Bool)
}

final class MyNFTPresenter: MyNFTPresenterProtocol {

    // MARK: - ViewController
    weak var view: MyNFTViewProtocol?

    // MARK: - Other properties
    var mockArrayOfNFT = [NFTModel]()

    // MARK: - Public methods
    func viewDidLoad() {
        getDataFromStorage()
        showOrHidePlaceholder()
    }

    func sortButtonTapped() {
        view?.showAlert()
    }

    func addOrRemoveNFTFromFav(nft: NFTModel, isNFTFav: Bool) {
        if isNFTFav {
            removeNFTFromFav(nft)
        } else {
            addNFTToFav(nft)
        }
    }

    func showOrHidePlaceholder() {
        let isDataEmpty = isArrayOfNFTEmpty()
        if isDataEmpty {
            view?.showPlaceholder()
        } else {
            view?.hideTableView()
        }
    }

    func getDataFromStorage() {
        let data = MockDataStorage.mockData
        guard let myNFT = data.nfts else { print("Ooops"); return }
        mockArrayOfNFT = myNFT
    }

    private func isArrayOfNFTEmpty() -> Bool {
        return mockArrayOfNFT.isEmpty
    }

    func getNumberOfRows() -> Int {
        return mockArrayOfNFT.count
    }

    func getNFT(with indexPath: IndexPath) -> NFTModel {
        let nft = mockArrayOfNFT[indexPath.row]
        return nft
    }

    func addNFTToFav(_ nft: NFTModel) {
        let storage = MockDataStorage()
        let nftToAddToFav = nft
        storage.addFavNFT(nftToAddToFav)
    }

    func removeNFTFromFav(_ nft: NFTModel) {
        let storage = MockDataStorage()
        let nftToRemoveFromFav = nft
        storage.removeFromFavNFT(nftToRemoveFromFav)
    }

    func priceSorting() {
        mockArrayOfNFT.sort {
            guard let priceString1 = $0.price,
                  let priceString2 = $1.price,
                  let priceDouble1 = Double(priceString1),
                  let priceDouble2 = Double(priceString2) else { print("Sorting problem"); return false}
            return priceDouble1 > priceDouble2
        }
        view?.updateTableView()
    }

    func ratingSorting() {
        mockArrayOfNFT.sort {
            guard let rating1 = $0.rating,
                  let rating2 = $1.rating else { print("Sorting problem"); return false}
            return rating1 > rating2
        }
        view?.updateTableView()
    }

    func nameSorting() {
        mockArrayOfNFT.sort {
            guard let rating1 = $0.name,
                  let rating2 = $1.name else { print("Sorting problem"); return false}
            return rating1 > rating2
        }
        view?.updateTableView()
    }

    func isNFTInFav(_ nft: NFTModel) -> Bool {
        guard let listOfFav = MockDataStorage.mockData.favoriteNFT else { return false }
        if listOfFav.contains(where: { $0.name == nft.name }) {
            return true
        } else {
            return false
        }
    }
}
