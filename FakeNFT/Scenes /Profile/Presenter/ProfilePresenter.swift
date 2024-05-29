//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol ProfilePresenterProtocol {
    func viewDidLoad()
    func getRowCount() -> Int
    func getRowName(indexPath: IndexPath) -> String
    func selectCell(indexPath: IndexPath)
    func editButtonTapped()
    func nameCell(indexPath: IndexPath) -> String
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
    }

    func viewDidLoad() {
        uploadDataFromStorage()
    }

    // MARK: - Public methods
    func nameCell(indexPath: IndexPath) -> String {
        let name = getRowName(indexPath: indexPath)
        var nameAndCount = ""

        switch name {
        case "Мои NFT": nameAndCount = "\(name) (\(getNFTCount()))"
        case "Избранные NFT": nameAndCount = "\(name) (\(getFavoriteNFTCount()))"
        default: nameAndCount = "\(name)"
        }
        return nameAndCount
    }



    func selectCell(indexPath: IndexPath) {
        switch indexPath.row {
        case 0: goToMyNFTScreen()
        case 1: goToFavNFTScreen()
        default: goToWebSiteScreen()
        }
    }

    func editButtonTapped() {
        goToEditProfileScreen()
    }

    func getMockData() ->  ProfileMockModel? {
        mockData
    }

    func uploadDataFromStorage() {
        mockData = MockDataStorage.mockData
        guard let data = mockData else { return }
        view?.updateUIWithMockData(data)
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

    private func goToMyNFTScreen() {
        navigation.goToView(.myNFT)
    }

    private func goToFavNFTScreen() {
        navigation.goToView(.FavNFT)
    }

    private func goToEditProfileScreen() {
        navigation.goToView(.editProfile)
    }

    private func goToWebSiteScreen() {
        navigation.goToView(.WebScreen, webSiteName: mockData?.website)
    }
}
