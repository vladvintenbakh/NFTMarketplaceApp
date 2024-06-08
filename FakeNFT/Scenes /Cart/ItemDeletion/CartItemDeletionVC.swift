//
//  CartItemDeletionVC.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

protocol CartItemDeletionVCProtocol: AnyObject {
    func setCartItemImage(image: UIImage)
}

final class CartItemDeletionVC: UIViewController {
    private let presenter: CartItemDeletionPresenterProtocol
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.frame = view.bounds
        return visualEffectView
    }()
    
    private let cardImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()
    
    private let confirmationLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        label.numberOfLines = 2
        label.textColor = .yaBlackLight
        label.font = .caption2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var deleteButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить", for: .normal)
        button.backgroundColor = .yaBlackLight
        button.titleLabel?.font = .bodyRegular
        button.tintColor = .yaRed
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вернуться", for: .normal)
        button.backgroundColor = .yaBlackLight
        button.titleLabel?.font = .bodyRegular
        button.tintColor = .yaWhiteLight
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let buttonStack = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    init(presenter: CartItemDeletionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachView(self)
        
        presenter.fetchCartItemImage()
        addSubviews()
        configConstraints()
    }
}

// MARK: UI Layout
extension CartItemDeletionVC {
    private func addSubviews() {
        view.addSubview(blurEffectView)
        
        let stackSubviews = [deleteButton, cancelButton]
        stackSubviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            buttonStack.addArrangedSubview(item)
        }
        
        let subviews = [cardImage, confirmationLabel, buttonStack]
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            cardImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            cardImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardImage.heightAnchor.constraint(equalToConstant: 108),
            cardImage.widthAnchor.constraint(equalToConstant: 108),
            
            confirmationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 97),
            confirmationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -97),
            confirmationLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 12),
            
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
            buttonStack.topAnchor.constraint(equalTo: confirmationLabel.bottomAnchor, constant: 20),
            buttonStack.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// MARK: Interaction Methods
extension CartItemDeletionVC {
    @objc private func deleteButtonPressed() {
        dismiss(animated: true)
        presenter.confirmDeletion()
    }
    
    @objc private func cancelButtonPressed() {
        dismiss(animated: true)
    }
}

// MARK: CartItemDeletionVCProtocol
extension CartItemDeletionVC: CartItemDeletionVCProtocol {
    func setCartItemImage(image: UIImage) {
        cardImage.image = image
    }
}
