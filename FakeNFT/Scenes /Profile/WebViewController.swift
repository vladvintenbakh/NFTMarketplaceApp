//
//  WebViewController.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.
//

import UIKit
import WebKit

protocol ProfileViewControllerDelegate {
    func passWebsiteName(_ website: String?)
}

final class WebViewController: UIViewController {

    // MARK: - UI Properties
    var webView: WKWebView!
    var websiteName: String?
    let network = NetworkManager()

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeb()
        setupLayout()
        showWebSite()
    }

    // MARK: - Private methods
    private func setupLayout() {
        view.backgroundColor = Constants.AppColors.appBackground
        view.fullViewWithSafeAreas(webView)
    }
}

extension WebViewController: WKNavigationDelegate {

    func setupWeb() {
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
    }

    private func showWebSite() {
        guard let urlString = websiteName,
              let url = URL(string: urlString) else { print("!!!!"); return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebViewController: ProfileViewControllerDelegate {
    
    func passWebsiteName(_ website: String?) {
        websiteName = website
    }
}
