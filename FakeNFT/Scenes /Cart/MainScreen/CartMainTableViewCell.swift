//
//  CartMainTableViewCell.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

protocol CartMainTableViewCellDelegate: AnyObject {
    func didPressRemoveFromCartButtonFor(indexPath: IndexPath)
}

final class CartMainTableViewCell: UITableViewCell {
    static let identifier = "CartMainTableViewCell"
    
    weak var delegate: CartMainTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    private let cardImage = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        return image
    }()
    
    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yaBlackLight
        label.font = .bodyBold
        return label
    }()
    
    private lazy var ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        return stack
    }()
    
    private let priceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.textColor = .yaBlackLight
        label.font = .caption2
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yaBlackLight
        label.font = .bodyBold
        label.textAlignment = .center
        return label
    }()
    
    private lazy var removeFromCartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "DeleteFromCartIcon"), for: .normal)
        button.addTarget(self, action: #selector(removeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        configConstraints()
        
        for index in 1...5 {
            let image = UIImageView()
            image.tag = index
            ratingStack.addArrangedSubview(image)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Layout
extension CartMainTableViewCell {
    private func addSubviews() {
        let subviews = [cardImage, nftNameLabel, ratingStack,
                        priceDescriptionLabel, priceValueLabel, removeFromCartButton]
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(item)
        }
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            cardImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            cardImage.heightAnchor.constraint(equalToConstant: 108),
            cardImage.widthAnchor.constraint(equalToConstant: 108),
            
            nftNameLabel.leadingAnchor.constraint(equalTo: cardImage.trailingAnchor, constant: 20),
            nftNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            
            ratingStack.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            ratingStack.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            
            priceDescriptionLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            priceDescriptionLabel.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 12),
            
            priceValueLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            priceValueLabel.topAnchor.constraint(equalTo: priceDescriptionLabel.bottomAnchor, constant: 2),
            
            removeFromCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            removeFromCartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Interaction Methods
extension CartMainTableViewCell {
    @objc private func removeButtonPressed() {
        guard let indexPath else { return }
        delegate?.didPressRemoveFromCartButtonFor(indexPath: indexPath)
    }
    
    func configUI(cartItem: CartItem) {
        nftNameLabel.text = cartItem.name
        cardImage.image = UIImage(named: cartItem.images[0])
        priceValueLabel.text = String(format: "%.2f ETH", cartItem.price)
        
        setRatingTo(cartItem.rating)
    }
    
    private func setRatingTo(_ rating: Int) {
        for (index, subview) in ratingStack.subviews.enumerated() {
            let imageName = index < rating ? "FilledRatingStar" : "UnfilledRatingStar"
            if let imageView = subview as? UIImageView {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
}
