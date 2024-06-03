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

    // MARK: - Properties
    weak var view: ProfileViewProtocol?
    var navigation: NavigationManager?
    private let network = DefaultNetworkClient()
    private let storage = ProfileStorage.shared
    private let profileNetwork = ProfileNetworkService()


    // MARK: - Life cycles
    func viewDidLoad() {
        uploadDataFromNetwork()
    }

    // MARK: - Private methods
    private func uploadDataFromNetwork() {
        let request = ProfileRequest()
        view?.showLoadingIndicator()
        network.send(request: request, type: ApiModel.self)  { [weak self] result in
            switch result {
            case .success(let data):
                self?.passDataToViewAndStorage(data)
                self?.uploadFavNFTFromNetwork()
                self?.view?.hideLoadingIndicator()
            case .failure(let error):
                print(error)
            }
        }
    }

    private func uploadFavNFTFromNetwork() {
        profileNetwork.uploadFavNFTFromNetwork()
    }



    private func passDataToViewAndStorage(_ dataFromNetwork: ApiModel?) {
        guard let data = dataFromNetwork else { return }
        let newProfile = ProfileModel(from: data)
        passProfileToStorage(newProfile)
        view?.updateUIWithNetworkData()
    }

    private func passProfileToStorage(_ profile: ProfileModel) {
        storage.profile = profile
    }
}

// MARK: - ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {

    func getRowCount() -> Int {
        RowNamesEnum.allCases.count
    }

    func selectCell(indexPath: IndexPath) {
        navigation?.goToView(indexPath: indexPath, webSiteName: storage.profile?.website)
    }

    func editButtonTapped() {
        navigation?.goToView(.editProfile)
    }

    func webSiteButtonTapped() {
        navigation?.goToView(.webScreen, webSiteName: storage.profile?.website)
    }

    func nameCell(indexPath: IndexPath) -> String {
        guard let nftCount = storage.profile?.nfts?.count,
              let favCount = storage.profile?.favoriteNFT?.count else { return ""}
        let name = RowNamesEnum.getRowName(indexPath: indexPath, nftCount: nftCount, favNFT: favCount)
        return name
    }
}
