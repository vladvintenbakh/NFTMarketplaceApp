//
//  WebViewController.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.
//

import UIKit
import WebKit


final class WebViewController: UIViewController {

    // MARK: - UI Properties
    var webView: WKWebView!

    // MARK: - Other Properties
    var presenter: WebViewPresenterProtocol?
    //    let network = NetworkManager()

    // MARK: - Init
    init(presenter: WebViewPresenterProtocol?) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeb()
        setupLayout()
        showWebSite()
    }

    // MARK: - Private methods
    private func setupNavigation() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.black
    }

    private func setupLayout() {
        setupNavigation()
        view.backgroundColor = UIColor.background
        view.fullViewWithSafeAreas(webView)
    }

    private func showWebSite() {
        guard let request = presenter?.configureRequest() else { print("Oops"); return }
        webView.load(request)
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {

    func setupWeb() {
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
    }
}
