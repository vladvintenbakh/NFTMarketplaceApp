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
    private let network = ProfileNetworkService()
    private let profileNetwork = ProfileNetworkService()

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
        Task {
            ProgressIndicator.show()
            for nftID in listOfFavNFT {
                let request = NFTRequest(id: nftID)

                do {
                    let data = try await network.sendNew(request: request, type: NFTModel.self)
                    // print("✅ Favorite NFT uploaded successfully")
                    guard let data else { return }
                    arrayOfFavNFT.append(data)
                } catch {
                    print(error.localizedDescription)
                }
            }
            ProgressIndicator.succeed()
            updateView()
        }
    }

    private func updateView() {
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
        listOfFavNFT.removeAll { $0 == nft.id }
        arrayOfFavNFT.removeAll { $0.name == nft.name }

        Task {
            do {
                try await profileNetwork.putLikes(listOfLikes: listOfFavNFT)
                updateView()
            } catch {
                print(error)
            }
        }
    }
}
