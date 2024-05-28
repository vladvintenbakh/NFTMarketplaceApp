//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol ProfilePresenterProtocol {
    func getRowCount() -> Int
    func getNFTCount() -> Int
    func getFavoriteNFTCount() -> Int
    func getRowName(indexPath: IndexPath) -> String
    func goToMyNFTScreen()
    func goToFavNFTScreen()
    func goToEditProfileScreen()
    func goToEditWebSiteScreen()
    func uploadDataFromStorage()
    func getMockData() ->  ProfileMockModel?
}

final class ProfilePresenter: ProfilePresenterProtocol {    

    // MARK: - View
    weak var view: ProfileViewProtocol?
    var navigation: NavigationManager

    // MARK: - Other properties
    let rowNames = ["Мои NFT", "Избранные NFT", "О разработчике"]
    var mockData: ProfileMockModel?

    // MARK: - Init
    init(view: ProfileViewProtocol?, navigation: NavigationManager) {
        self.view = view
        self.navigation = navigation

        uploadDataFromStorage()
    }

    // MARK: - Public methods
    func getMockData() ->  ProfileMockModel? {
        mockData
    }

    func uploadDataFromStorage() {
        mockData = MockDataStorage.mockData
    }

    func getRowCount() -> Int {
        rowNames.count
    }

    func getNFTCount() -> Int {
        mockData?.nfts?.count ?? 0
    }

    func getFavoriteNFTCount() -> Int {
        mockData?.favoriteNFT?.count ?? 0
    }

    func getRowName(indexPath: IndexPath) -> String {
        rowNames[indexPath.row]
    }

    func goToMyNFTScreen() {
        navigation.goToView(.myNFT)
    }

    func goToFavNFTScreen() {
        navigation.goToView(.FavNFT)
    }

    func goToEditProfileScreen() {
        navigation.goToView(.editProfile)
    }

    func goToEditWebSiteScreen() {
        navigation.goToView(.WebScreen, webSiteName: mockData?.website)
    }
}
