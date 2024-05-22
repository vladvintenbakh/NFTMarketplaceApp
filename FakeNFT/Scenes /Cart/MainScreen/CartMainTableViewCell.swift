//
//  CartMainTableViewCell.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

protocol CartMainTableViewCellDelegate: AnyObject {
    func didPressRemoveFromCartButton()
}

final class CartMainTableViewCell: UITableViewCell {
    static let identifier = "CartMainTableViewCell"
    
    weak var delegate: CartMainTableViewCellDelegate?
    
    private let cardImage = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.image = UIImage(named: "MockNFTCard1")
        return image
    }()
    
    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yaBlackLight
        label.font = .bodyBold
        label.text = "April"
        return label
    }()
    
    private let ratingStack: UIStackView = {
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
        label.text = "1,78 ETH"
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Layout
extension CartMainTableViewCell {
    private func addSubviews() {
        for index in 1...5 {
            let imageName = index < 3 ? "FilledRatingStar" : "UnfilledRatingStar"
            let image = UIImageView(image: UIImage(named: imageName))
            image.tag = index
            ratingStack.addArrangedSubview(image)
        }
        
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
    @objc func removeButtonPressed() {
        delegate?.didPressRemoveFromCartButton()
    }
}
