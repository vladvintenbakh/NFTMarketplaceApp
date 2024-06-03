//
//  MockData.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 27.05.2024.
//

import Foundation

final class ProfileStorage {

    static let shared = ProfileStorage()

    private init() { }

    var profile: ProfileModel?

    var favNFT: [NFTModel]?

    let network = ProfileNetworkService()

    func updateDataAfterEditing(newData: EditedDataModel) {
        profile?.name = newData.name
        profile?.description = newData.description
        profile?.website = newData.website

        Task {
            do {
                try await network.putPersonalData(newPersonalData: newData)
                print("✅ Personal data successfully updated")
            } catch {
                print(error)
            }
        }
    }

    func addFavNFTToStorage(_ nftToAddToStorage: NFTModel) {
        guard let nftToAdd = nftToAddToStorage.id else { return }
        profile?.favoriteNFT?.append(nftToAdd)
        favNFT?.append(nftToAddToStorage)
        print("✅ NFT successfully added to storage")
    }

    func removeFavNFTFromStorage(_ nftToRemoveFromStorage: NFTModel) {
        guard let nftToRemove = nftToRemoveFromStorage.id else { return }
        profile?.favoriteNFT?.removeAll { $0 == nftToRemove }
        favNFT?.removeAll { $0.id == nftToRemove }
        print("✅ NFT successfully removed to storage")
    }
}
