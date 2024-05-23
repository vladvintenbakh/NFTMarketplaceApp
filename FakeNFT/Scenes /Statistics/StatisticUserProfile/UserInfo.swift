//
//  UserInfo.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 23.05.24.
//

import Foundation

protocol UserInfoPresenterProtocol: AnyObject {
    func viewDidLoad()
    func nftCollectionButtonDidTap()
}

final class UserInfoPresenter: UserInfoPresenterProtocol {
    var onNFTCollectionButtonTap: (() -> Void)?
    private weak var view: UserInfoViewProtocol?
    private let user: User
    
    init(view: UserInfoViewProtocol, user: User) {
        self.view = view
        self.user = user
    }
    
    func viewDidLoad() {
        view?.updateUserInfo(username: user.username, description: user.description, avatar: user.avatar)
    }
    
    func nftCollectionButtonDidTap() {
        onNFTCollectionButtonTap?()
    }
}
