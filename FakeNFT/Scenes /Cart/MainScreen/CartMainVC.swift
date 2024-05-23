//
//  CartMainVC.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 19/5/24.
//

import UIKit

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
        label.text = "3 NFT"
        label.textColor = .yaBlackLight
        label.font = .caption1
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "5,34 ETH"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sortButton = UIButton()
        sortButton.setImage(UIImage(named: "CartSortIcon"), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
        
        placeholderLabel.isHidden = true
        
        cartItemTable.dataSource = self
        
        addSubviews()
        configConstraints()
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
    @objc func paymentButtonPressed() {
        let navigationVC = UINavigationController(rootViewController: PaymentVC())
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
}

// MARK: UITableViewDataSource
extension CartMainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartMainTableViewCell.identifier,
            for: indexPath
        ) as? CartMainTableViewCell
        guard let cell else { return UITableViewCell() }
        cell.delegate = self
        return cell
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
