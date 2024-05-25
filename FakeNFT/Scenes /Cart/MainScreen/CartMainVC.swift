//
//  CartMainVC.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 19/5/24.
//

import UIKit

protocol CartMainVCProtocol {
    
}

final class CartMainVC: UIViewController {
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .yaBlackLight
        label.text = "Корзина пуста"
        label.textAlignment = .center
        return label
    }()
    
    private let cartItemTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.allowsSelection = false
        table.register(CartMainTableViewCell.self,
                       forCellReuseIdentifier: CartMainTableViewCell.identifier)
        return table
    }()
    
    private let grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .yaLightGrayLight
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let itemCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yaBlackLight
        label.font = .caption1
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yaGreen
        label.font = .bodyBold
        return label
    }()
    
    private lazy var proceedToPaymentButton: UIButton = {
        let button = CartReusableUIComponents.standardButton(text: "К оплате")
        button.addTarget(self, action: #selector(paymentButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var itemInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private lazy var bottomHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 24
        return stack
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CartSortIcon"), for: .normal)
        button.addTarget(self, action: #selector(sortButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let presenter: CartMainPresenter
    
    init(presenter: CartMainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachView(self)
        
        cartItemTable.dataSource = self
        
        addSubviews()
        configConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

// MARK: UI Layout
extension CartMainVC {
    private func addSubviews() {
        let infoStackSubviews = [itemCountLabel, totalPriceLabel]
        infoStackSubviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            itemInfoStack.addArrangedSubview(item)
        }
        
        let bottomStackSubviews = [itemInfoStack, proceedToPaymentButton]
        bottomStackSubviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            bottomHorizontalStack.addArrangedSubview(item)
        }
        
        let subviews = [placeholderLabel, cartItemTable, grayBackgroundView, bottomHorizontalStack]
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            cartItemTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartItemTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartItemTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            grayBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayBackgroundView.topAnchor.constraint(equalTo: cartItemTable.bottomAnchor),
            grayBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            bottomHorizontalStack.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor, constant: 16),
            bottomHorizontalStack.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor, constant: -16),
            bottomHorizontalStack.topAnchor.constraint(equalTo: grayBackgroundView.topAnchor, constant: 16),
            bottomHorizontalStack.bottomAnchor.constraint(equalTo: grayBackgroundView.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: Interaction Methods
extension CartMainVC {
    @objc private func paymentButtonPressed() {
        let navigationVC = UINavigationController(rootViewController: PaymentVC())
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
    
    @objc private func sortButtonPressed() {
        let alert = AlertUtility.cartMainScreenSortAlert()
        present(alert, animated: true)
    }
    
    func toggleEmptyPlaceholderTo(_ isCartEmpty: Bool) {
        placeholderLabel.isHidden = !isCartEmpty
        cartItemTable.isHidden = isCartEmpty
        grayBackgroundView.isHidden = isCartEmpty
        bottomHorizontalStack.isHidden = isCartEmpty
        navigationItem.rightBarButtonItem = isCartEmpty ? nil : UIBarButtonItem(customView: sortButton)
    }
    
    func updateTotals() {
        cartItemTable.reloadData()
        
        let itemCount = presenter.numberOfCartItems()
        itemCountLabel.text = "\(itemCount) NFT"
        
        let totalPrice = presenter.cartTotalPrice()
        totalPriceLabel.text = String(format: "%.2f ETH", totalPrice)
    }
}

// MARK: UITableViewDataSource
extension CartMainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCartItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartMainTableViewCell.identifier,
            for: indexPath
        ) as? CartMainTableViewCell
        guard let cell else { return UITableViewCell() }
        let configuredCell = presenter.configCell(cell, at: indexPath)
        configuredCell.delegate = self
        return configuredCell
    }
}

// MARK: CartMainTableViewCellDelegate
extension CartMainVC: CartMainTableViewCellDelegate {
    func didPressRemoveFromCartButton() {
        let deletionVC = CartItemDeletionVC()
        deletionVC.modalPresentationStyle = .overFullScreen
        present(deletionVC, animated: true)
    }
}
