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

final class MyNFTPresenter {

    // MARK: - ViewController
    weak var view: MyNFTViewProtocol?
    private let network = ProfileNetworkService()
    private let profileNetwork = ProfileNetworkService()

    // MARK: - Other properties
    private var arrayOfNFT = [NFTModel]()
    private var listOfNFT = [String]()

    // MARK: - Private methods
    private func getDataFromStorage() {
        let data = ProfileStorage.profile
        guard let myNFT = data?.nfts else { print("Ooops"); return }
        listOfNFT = myNFT
    }

    private func uploadNFTFromNetwork() {
        Task {
            ProgressIndicator.show()
            for nftID in listOfNFT {
                let request = NFTRequest(id: nftID)

                do {
                    let data = try await network.sendNew(request: request, type: NFTModel.self)
                    // print("✅ Favorite NFT uploaded successfully")
                    guard let data else { return }
                    arrayOfNFT.append(data)
                } catch {
                    print(error.localizedDescription)
                }
            }
            ProgressIndicator.succeed()
            view?.updateTableView()
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

    private func isArrayOfNFTEmpty() -> Bool {
        return arrayOfNFT.isEmpty
    }

    private func addNFTToFav(_ nft: NFTModel) {
        guard let nftToAppend = nft.id else { return }

        ProfileStorage.profile?.favoriteNFT?.append(nftToAppend)

        Task {
            await makeLikes()
        }
    }

    private func removeNFTFromFav(_ nft: NFTModel) {
        guard let nftToRemove = nft.id else { return }

        ProfileStorage.profile?.favoriteNFT?.removeAll { $0 == nftToRemove }

        Task {
            await makeLikes()
        }
    }

    private func makeLikes() async {
        let favoriteNFT = ProfileStorage.profile?.favoriteNFT
        guard let listOfFavs = favoriteNFT else { return }
        do {
            try await profileNetwork.putLikes(listOfLikes: listOfFavs)
            print("✅ listOfFav updated successfully")
            view?.updateTableView()
        } catch {
            print(error)
        }
    }
}


// MARK: - MyNFTPresenterProtocol
extension  MyNFTPresenter: MyNFTPresenterProtocol {
    
    func viewDidLoad() {
        getDataFromStorage()
        uploadNFTFromNetwork()
    }

    func sortButtonTapped() {
        view?.showAlert()
    }

    func getNumberOfRows() -> Int {
        return arrayOfNFT.count
    }

    func getNFT(with indexPath: IndexPath) -> NFTModel {
        let nft = arrayOfNFT[indexPath.row]
        return nft
    }

    func priceSorting() {
        arrayOfNFT.sort {
            guard let price1 = $0.price,
                  let price2 = $1.price else { print("Sorting problem"); return false }
            return price1 > price2
        }
        view?.updateTableView()
    }

    func ratingSorting() {
        arrayOfNFT.sort {
            guard let rating1 = $0.rating,
                  let rating2 = $1.rating else { print("Sorting problem"); return false}
            return rating1 > rating2
        }
        view?.updateTableView()
    }

    func nameSorting() {
        arrayOfNFT.sort {
            guard let rating1 = $0.name,
                  let rating2 = $1.name else { print("Sorting problem"); return false}
            return rating1 > rating2
        }
        view?.updateTableView()
    }

    func isNFTInFav(_ nft: NFTModel) -> Bool {
        guard let listOfFav = ProfileStorage.profile?.favoriteNFT else { return false }
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
