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
    let network = DefaultNetworkClient()

    // MARK: - Other properties
    private var profile: ProfileModel?

    // MARK: - Life cycles
    func viewDidLoad() {
        uploadDataFromNetwork()
    }

    // MARK: - Private methods
    private func uploadDataFromNetwork() {
        let request = ProfileRequest()

        network.send(request: request, type: ApiModel.self)  { [weak self] result in
            switch result {
            case .success(let data):
                self?.passDataToViewAndStorage(data)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func passDataToViewAndStorage(_ dataFromNetwork: ApiModel?) {
        guard let data = dataFromNetwork else { return }
        let newProfile = ProfileModel(from: data)
        passProfileToStorage(newProfile)
        updateDataHere()
        view?.updateUIWithNetworkData(newProfile)
    }

    private func passProfileToStorage(_ profile: ProfileModel) {
        ProfileStorage.profile = profile
    }

    private func updateDataHere() {
        profile = ProfileStorage.profile
    }

//    private func uploadDataFromStorage() {
//        mockData = MockDataStorage.mockData
//        guard let data = mockData else { return }
//        view?.updateUIWithMockData(data)
//    }

    private func getNFTCount() -> Int {
        profile?.nfts?.count ?? 0
    }

    private func getFavoriteNFTCount() -> Int {
        profile?.favoriteNFT?.count ?? 0
    }
}

// MARK: - ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {

    func getRowCount() -> Int {
        RowNamesEnum.allCases.count
    }

    func selectCell(indexPath: IndexPath) {
        navigation?.goToView(indexPath: indexPath, webSiteName: profile?.website)
    }

    func editButtonTapped() {
        navigation?.goToView(.editProfile)
    }

    func webSiteButtonTapped() {
        navigation?.goToView(.webScreen, webSiteName: profile?.website)
    }

    func nameCell(indexPath: IndexPath) -> String {
        let nftCount = getNFTCount()
        let favCount = getFavoriteNFTCount()
        let name = RowNamesEnum.getRowName(indexPath: indexPath, nftCount: nftCount, favNFT: favCount)
        return name
    }
}
