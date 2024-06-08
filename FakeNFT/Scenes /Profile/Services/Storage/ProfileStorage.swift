//
//  MockData.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 27.05.2024.
//

import Foundation

protocol ProfileStorageProtocol: AnyObject {
    var profile: ProfileModel? { get set }
    var favNFT: [NFTModelData]? { get set }
    var myNFT: [NFTModelData]? { get set }

    func addFavNFTToStorage(_ nftToAddToStorage: NFTModelData)
    func removeFavNFTFromStorage(_ nftToRemoveFromStorage: NFTModelData)
    func updateDataAfterEditing(newData: EditedDataModel)
}

final class ProfileStorage: ProfileStorageProtocol {

    static let shared = ProfileStorage()

    private init() { }

    var profile: ProfileModel?

    var favNFT: [NFTModelData]?

    var myNFT: [NFTModelData]?

    lazy var network = ProfileNetworkService()

    func updateDataAfterEditing(newData: EditedDataModel) {
        profile?.name = newData.name
        profile?.description = newData.description
        profile?.website = newData.website
        profile?.avatar = newData.avatar

        Task { [weak self] in
            guard let self else { return }
            do {
                try await network.putPersonalData(newPersonalData: newData)
                print("✅ Personal data successfully updated")
            } catch {
                print(error)
            }
        }
    }

    func addFavNFTToStorage(_ nftToAddToStorage: NFTModelData) {
        guard let nftToAdd = nftToAddToStorage.id else { return }
        profile?.favoriteNFT?.append(nftToAdd)
        favNFT?.append(nftToAddToStorage)
        print("✅ NFT successfully added to storage")
    }

    func removeFavNFTFromStorage(_ nftToRemoveFromStorage: NFTModelData) {
        guard let nftToRemove = nftToRemoveFromStorage.id else { return }
        profile?.favoriteNFT?.removeAll { $0 == nftToRemove }
        favNFT?.removeAll { $0.id == nftToRemove }
        print("✅ NFT successfully removed to storage")
    }
}
