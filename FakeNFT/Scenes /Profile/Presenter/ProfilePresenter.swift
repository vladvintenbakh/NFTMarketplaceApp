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
    func selectCell(indexPath: IndexPath)
    func editButtonTapped()
    func webSiteButtonTapped()
    func nameCell(indexPath: IndexPath) -> String
}

final class ProfilePresenter {

    // MARK: - View
    weak var view: ProfileViewProtocol?
    var navigation: NavigationManager?

    // MARK: - Other properties
    private var mockData: ProfileMockModel?

    // MARK: - Private methods
    private func uploadDataFromStorage() {
        mockData = MockDataStorage.mockData
        guard let data = mockData else { return }
        view?.updateUIWithMockData(data)
    }

    private func getNFTCount() -> Int {
        mockData?.nfts?.count ?? 0
    }

    private func getFavoriteNFTCount() -> Int {
        mockData?.favoriteNFT?.count ?? 0
    }
}

// MARK: - ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {

    func viewDidLoad() {
        uploadDataFromStorage()
    }

    func getRowCount() -> Int {
        RowNamesEnum.allCases.count
    }

    func selectCell(indexPath: IndexPath) {
        navigation?.goToView(indexPath: indexPath, webSiteName: mockData?.website)
    }

    func editButtonTapped() {
        navigation?.goToView(.editProfile)
    }

    func webSiteButtonTapped() {
        navigation?.goToView(.webScreen, webSiteName: mockData?.website)
    }

    func nameCell(indexPath: IndexPath) -> String {
        let nftCount = getNFTCount()
        let favCount = getFavoriteNFTCount()
        let name = RowNamesEnum.getRowName(indexPath: indexPath, nftCount: nftCount, favNFT: favCount)
        return name
    }
}
