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
    private var arrayOfFavNFT = [NFTModel]()
    private var listOfFavNFT = [String]()
    private let network = DefaultNetworkClient()

    // MARK: - Life cycle
    func viewDidLoad() {
        getArrayOfFavFromStorage()

        uploadFavNFTFromNetwork()

    }

    // MARK: - Private methods
    private func getArrayOfFavFromStorage() {
        guard let profile = ProfileStorage.profile,
              let favoriteNFT = profile.favoriteNFT else { return }
        listOfFavNFT = favoriteNFT
    }

    private func uploadFavNFTFromNetwork() {
        guard let id = listOfFavNFT.first else { return }
        let request = NFTRequest(id: id)

        network.send(request: request, type: NFTModel.self)  { [weak self] result in
            switch result {
            case .success(let data):
                print("✅ Favorite NFT uploaded successfully")
                self?.passDataToViewAndStorage(data)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func passDataToViewAndStorage(_ dataFromNetwork: NFTModel) {
        arrayOfFavNFT.append(dataFromNetwork)
        view?.updateUI()
        showOrHidePlaceholder()
    }

    private func showOrHidePlaceholder() {
        if listOfFavNFT.isEmpty {
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
        let storage = MockDataStorage()
        let nftToRemoveFromFav = nft
//        storage.removeFromFavNFT(nftToRemoveFromFav)

//        uploadDataFromStorage()

        view?.updateUI()
    }

}
