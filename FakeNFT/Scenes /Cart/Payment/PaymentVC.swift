//
//  PaymentVC.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

final class PaymentVC: UIViewController {
    
    private let presenter: PaymentPresenter
    
    private let currencyCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.allowsMultipleSelection = false
        collection.allowsSelection = true
        collection.isUserInteractionEnabled = true
        collection.register(PaymentCollectionViewCell.self,
                            forCellWithReuseIdentifier: PaymentCollectionViewCell.identifier)
        return collection
    }()
    
    private let grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .yaLightGrayLight
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let userAgreementDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.textColor = .yaBlackLight
        label.font = .caption2
        return label
    }()
    
    private lazy var userAgreementLinkLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользовательского соглашения"
        label.textColor = .yaBlue
        label.font = .caption2
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGestureRecognizer)
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button = CartReusableUIComponents.standardButton(text: "Оплатить")
        button.isEnabled = false
        button.addTarget(self, action: #selector(payButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                   action: #selector(userAgreementLinkPressed))
    
    init(presenter: PaymentPresenter) {
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
        
        setUpNavigationBar()
        addSubviews()
        configConstraints()
        
        currencyCollection.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        currencyCollection.dataSource = self
        currencyCollection.delegate = self
    }
}

// MARK: UI Layout
extension PaymentVC {
    private func setUpNavigationBar() {
        navigationItem.title = "Выберите способ оплаты"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.bodyBold,
            .foregroundColor: UIColor.yaBlackLight
        ]
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "NavbarBackButton"), for: .normal)
        backButton.tintColor = .yaBlackLight
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func addSubviews() {
        let bottomSubviews = [userAgreementDescriptionLabel, userAgreementLinkLabel, payButton]
        bottomSubviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            grayBackgroundView.addSubview(item)
        }
        
        let subviews = [currencyCollection, grayBackgroundView]
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            currencyCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currencyCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currencyCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            grayBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayBackgroundView.topAnchor.constraint(equalTo: currencyCollection.bottomAnchor),
            grayBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            grayBackgroundView.heightAnchor.constraint(equalToConstant: 186),
            
            userAgreementDescriptionLabel.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor,
                                                                   constant: 16),
            userAgreementDescriptionLabel.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor,
                                                                    constant: -16),
            userAgreementDescriptionLabel.topAnchor.constraint(equalTo: grayBackgroundView.topAnchor,
                                                               constant: 16),
            
            userAgreementLinkLabel.leadingAnchor.constraint(equalTo: userAgreementDescriptionLabel.leadingAnchor),
            userAgreementLinkLabel.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor,
                                                             constant: -16),
            userAgreementLinkLabel.topAnchor.constraint(equalTo: userAgreementDescriptionLabel.bottomAnchor, constant: 4),
            
            payButton.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor, constant: -12),
            payButton.topAnchor.constraint(equalTo: userAgreementLinkLabel.bottomAnchor, constant: 16),
            payButton.bottomAnchor.constraint(equalTo: grayBackgroundView.bottomAnchor, constant: -50)
        ])
    }
}

// MARK: Interaction Methods
extension PaymentVC {
    @objc private func backButtonPressed() {
        presenter.returnToCartMainScreen()
    }
    
    @objc private func payButtonPressed() {
        presenter.processPaymentAttempt()
    }
    
    @objc private func userAgreementLinkPressed() {
        presenter.loadUserAgreement()
    }
}

// MARK: UICollectionViewDataSource
extension PaymentVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCurrencies()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaymentCollectionViewCell.identifier,
            for: indexPath
        ) as? PaymentCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        
        let configuredCell = presenter.configCell(cell, at: indexPath)
        
        return configuredCell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PaymentVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (currencyCollection.frame.width / 2) - 23
        let height = 46.0
        return CGSize(width: width, height: height)
    }
}

extension PaymentVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PaymentCollectionViewCell
        guard let cell else { return }
        
        payButton.isEnabled = true
        cell.toggleSelectionTo(true)
        
        presenter.setSelectedCurrency(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PaymentCollectionViewCell
        guard let cell else { return }
        
        cell.toggleSelectionTo(false)
    }
}
