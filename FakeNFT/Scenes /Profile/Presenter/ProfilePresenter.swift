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
    func viewHasGotNotification()
}

final class ProfilePresenter: ProfilePresenters {

    // MARK: - Properties
    weak var view: ProfileViewProtocol?
    var navigation: NavigationManager?

    // MARK: - Life cycles
    func viewDidLoad() {
        uploadDataFromNetwork()
    }

    // MARK: - Private methods
    private func uploadDataFromNetwork() {
        view?.showLoadingIndicator()
        Task { [weak self] in
            guard let self else { return }
            do {
                let profile = try await network.getProfile()
                self.passDataToViewAndStorage(profile)
                self.uploadNFTAndFavNFTFromNetwork()
            } catch {
                print(error)
            }
        }
    }

    private func uploadNFTAndFavNFTFromNetwork() {
        Task { [weak self] in
            guard let self else { return }
            await self.uploadMyNFTFromNetwork()
            await self.uploadFavNFTFromNetwork()
            self.view?.hideLoadingIndicator()
        }
    }

    private func uploadMyNFTFromNetwork() async {
        await network.getMyNFTFromNetwork()
    }

    private func uploadFavNFTFromNetwork() async {
        await network.getFavNFTFromNetwork()
    }

    private func passDataToViewAndStorage(_ dataFromNetwork: ApiModel?) {
        guard let data = dataFromNetwork else { return }
        let newProfile = ProfileModel(from: data)
        passProfileToStorage(newProfile)
        view?.updateUIWithNetworkData(newProfile)
    }

    private func passProfileToStorage(_ profile: ProfileModel) {
        storage.profile = profile
    }

    func viewHasGotNotification() {
        guard let profile = storage.profile else { return }
        view?.updateUIWithNetworkData(profile)
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
