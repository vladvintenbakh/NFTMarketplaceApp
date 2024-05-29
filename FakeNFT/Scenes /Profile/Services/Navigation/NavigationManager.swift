//
//  NavigationManager.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 27.05.2024.
//

import UIKit

enum Views {
    case myNFT
    case FavNFT
    case aboutAuthor
    case editProfile
    case WebScreen
}

final class NavigationManager {

    var navigation: UINavigationController?
    weak var rootVC: UIViewController?

    init(navigation: UINavigationController?, rootVC: UIViewController?) {
        self.navigation = navigation
        self.rootVC = rootVC
    }

    func goToView(_ view: Views, webSiteName: String? = nil) {
        switch view {
        case .myNFT:
            let presenter = MyNFTPresenter()
            let view = MyNFTViewController(presenter: presenter)
            presenter.view = view
            navigation?.pushViewController(view, animated: true)
        case .FavNFT:
            let presenter = FavoriteNFTPresenter()
            let view = FavoriteNFTViewController(presenter: presenter)
            presenter.view = view
            navigation?.pushViewController(view, animated: true)
        case .aboutAuthor:
            let presenter = WebViewPresenter()
            let vc = WebViewController(presenter: presenter)
            navigation?.pushViewController(vc, animated: true)
        case .editProfile:
            let presenter = EditProfilePresenter()
            let view = EditProfileViewController(presenter: presenter)
            presenter.view = view
            let EditVC = UINavigationController(rootViewController: view)
            rootVC?.present(EditVC, animated: true)
        case .WebScreen:
            let presenter = WebViewPresenter(websiteName: webSiteName)
            let vc = WebViewController(presenter: presenter)
            navigation?.pushViewController(vc, animated: true)
        }
    }
}
