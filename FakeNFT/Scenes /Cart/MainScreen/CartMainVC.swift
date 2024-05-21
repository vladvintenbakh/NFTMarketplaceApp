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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configConstraints()
    }
}

// MARK: UI Layout
extension CartMainVC {
    private func addSubviews() {
        let subviews = [placeholderLabel]
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
