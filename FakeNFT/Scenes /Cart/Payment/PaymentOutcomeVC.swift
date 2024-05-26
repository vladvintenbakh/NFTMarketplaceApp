//
//  PaymentOutcomeVC.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

final class PaymentOutcomeVC: UIViewController {
    private let presenter: PaymentOutcomePresenter
    
    private let successfulPaymentImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "SuccessfulPaymentImage"))
        return image
    }()
    
    private let successMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Успех! Оплата прошла, поздравляем с покупкой!"
        label.textColor = .yaBlackLight
        label.font = .headline3
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var backToCatalogButton: UIButton = {
        let button = CartReusableUIComponents.standardButton(text: "Вернуться в каталог")
        button.addTarget(self, action: #selector(backToCatalogButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init(presenter: PaymentOutcomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yaWhiteLight
        
        presenter.attachView(self)
        
        addSubviews()
        configConstraints()
    }
}

// MARK: UILayout
extension PaymentOutcomeVC {
    private func addSubviews() {
        let subviews = [successfulPaymentImage, successMessageLabel, backToCatalogButton]
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            successfulPaymentImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            successfulPaymentImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successfulPaymentImage.heightAnchor.constraint(equalToConstant: 278),
            successfulPaymentImage.widthAnchor.constraint(equalToConstant: 278),
            
            successMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            successMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            successMessageLabel.topAnchor.constraint(equalTo: successfulPaymentImage.bottomAnchor, constant: 20),
            
            backToCatalogButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backToCatalogButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backToCatalogButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                        constant: -16),
            backToCatalogButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: Interaction Methods
extension PaymentOutcomeVC {
    @objc private func backToCatalogButtonPressed() {
        presenter.initiateReturnToCatalog()
    }
    
    func returnToCatalog() {
        let tabBarController = view.window?.rootViewController as? TabBarController
        guard let tabBarController else { return }
        tabBarController.selectedIndex = 1
        view.window?.rootViewController?.dismiss(animated: true)
    }
}
