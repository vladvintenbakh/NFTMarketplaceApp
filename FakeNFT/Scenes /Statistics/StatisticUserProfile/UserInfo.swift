//
//  UserInfo.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 23.05.24.
//

import Foundation

protocol UserInfoPresenterProtocol: AnyObject {
    var onNFTCollectionButtonTap: (() -> Void)? { get set }
    var onUserWebsiteButtonTap: (() -> Void)? { get set }
    var currentUser: User { get }
    var servicesAssembly: ServicesAssembly { get }
    func nftCollectionButtonDidTap()
    func userWebsiteButtonDidTap()
}

final class UserInfoPresenter: UserInfoPresenterProtocol {
    var onNFTCollectionButtonTap: (() -> Void)?
    var onUserWebsiteButtonTap: (() -> Void)?

    private(set) var currentUser: User

    var servicesAssembly: ServicesAssembly

    init(for currentUser: User, servicesAssemly: ServicesAssembly) {
        self.currentUser = currentUser
        self.servicesAssembly = servicesAssemly
    }

    func nftCollectionButtonDidTap() {
        onNFTCollectionButtonTap?()
    }

    func userWebsiteButtonDidTap() {
        onUserWebsiteButtonTap?()
    }
}
