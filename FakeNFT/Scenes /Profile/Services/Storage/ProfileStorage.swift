//
//  MockData.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 27.05.2024.
//

import Foundation

final class ProfileStorage {

    static var profile: ProfileModel?

    let network = ProfileNetworkService()

    func updateDataAfterEditing(newData: EditedDataModel) {
        ProfileStorage.profile?.name = newData.name
        ProfileStorage.profile?.description = newData.description
        ProfileStorage.profile?.website = newData.website

        Task {
            do {
                try await network.putPersonalData(newPersonalData: newData)
                print("✅ Personal data updated successfully")
            } catch {
                print(error)
            }
        }
    }
}



//
//    func addFavNFT(_ nftToAddToStorage: NFTModel) {
//        MockDataStorage.mockData.favoriteNFT?.append(nftToAddToStorage)
//        print("NFT added successfully")
//    }
//
//    func removeFromFavNFT(_ nftToRemoveFromStorage: NFTModel) {
//        MockDataStorage.mockData.favoriteNFT?.removeAll { $0.name == nftToRemoveFromStorage.name }
//        print("NFT removed successfully")
//    }
//}
