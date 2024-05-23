//
//  WebViewPresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol WebViewPresenterProtocol {
    func configureRequest() -> URLRequest?
}

protocol ProfileViewControllerDelegate {
    func passWebsiteName(_ website: String?)
}

final class WebViewPresenter: WebViewPresenterProtocol {

    weak var view: WebViewController?
    var websiteName: String?

    func configureRequest() -> URLRequest? {
        guard let urlString = websiteName,
              let url = URL(string: urlString) else { print("!!!!"); return nil}
        let request = URLRequest(url: url)
        return request
    }
}

// MARK: - ProfileViewControllerDelegate
extension WebViewPresenter: ProfileViewControllerDelegate {

    func passWebsiteName(_ website: String?) {
        websiteName = website
    }
}

