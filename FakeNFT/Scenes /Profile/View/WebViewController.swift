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
    var presenter: WebViewPresenterProtocol
    let progress = UIProgressView(progressViewStyle: .bar)

    // MARK: - Init
    init(presenter: WebViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeb()
        setupLayout()
        setupProgressBar()
        showWebSite()
    }

    // MARK: - Private methods
    private func setupLayout() {
        setupNavigation()
        view.backgroundColor = UIColor.backgroundActive
        view.fullViewWithSafeAreas(webView)
    }

    private func setupNavigation() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.segmentActive
    }

    private func showWebSite() {
        guard let request = presenter.configureRequest() else { print("Oops"); return }
        webView.load(request)
    }
}

// MARK: - ProgressBar
extension WebViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progress.progress = Float(webView.estimatedProgress)
            progress.isHidden = webView.estimatedProgress >= 1.0
        }
    }

    private func setupProgressBar() {
        view.addSubViews([progress])
        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progress.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {

    func setupWeb() {
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
    }
}
