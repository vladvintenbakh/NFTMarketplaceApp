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

final class WebViewPresenter {

    weak var view: WebViewController?
    private var websiteName: String?

    init(view: WebViewController? = nil, websiteName: String? = nil) {
        self.view = view
        self.websiteName = websiteName
    }
}

// MARK: - WebViewPresenterProtocol
extension WebViewPresenter: WebViewPresenterProtocol {
    
    func configureRequest() -> URLRequest? {
        guard let urlString = websiteName,
              let url = URL(string: urlString) else { print("Issue with URL"); return nil}
        let request = URLRequest(url: url)
        return request
    }
}
