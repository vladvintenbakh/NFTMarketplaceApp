//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol ProfilePresenterProtocol {
    var mockData: ProfileModel { get }
    var navigation: NavigationManager { get }
    var nftCount: Int { get }
    var favoriteNFTCount: Int { get }

    func getRowCount() -> Int
    func getRowName(indexPath: IndexPath) -> String
    func goToMyNFTScreen()
    func goToFavNFTScreen()
    func goToEditProfileScreen()
    func goToEditWebSiteScreen()
}

final class ProfilePresenter: ProfilePresenterProtocol {

    // MARK: - View
    weak var view: ProfileViewProtocol?
    var navigation: NavigationManager

    // MARK: - Other properties
    let rowNames = ["Мои NFT", "Избранные NFT", "О разработчике"]
    var mockData = MockDataStorage.mockData

    var nftCount: Int {
        mockData.nfts?.count ?? 0
    }

    var favoriteNFTCount: Int {
        mockData.favoriteNFT?.count ?? 0
    }

    // MARK: - Init
    init(view: ProfileViewProtocol?, navigation: NavigationManager) {
        self.view = view
        self.navigation = navigation
    }

    // MARK: - Public methods
    func getRowCount() -> Int {
        rowNames.count
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
        navigation.goToView(.WebScreen, webSiteName: mockData.website)
    }
}
