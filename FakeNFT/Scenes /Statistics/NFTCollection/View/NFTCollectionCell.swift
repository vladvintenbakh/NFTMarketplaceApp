//
//  NFTCollectionCell.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 26.05.24.
//

import UIKit

final class NFTCollectionCell: UICollectionViewCell {
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .segmentActive
        return label
    }()
    
    private lazy var nftRatingView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = Constants.ratingStarsSpacing
        return stackView
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .segmentActive
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "whiteLike"), for: .normal)
        return button
    }()
    
    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "basket"), for: .normal)
        return button
    }()
    
    private var nftRating = 0 {
        didSet {
            updateRatingStarViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(using nft: NFT) {
        nftRating = nft.raiting
        nftImageView.image = nft.nftImg
        nftPriceLabel.text = nft.price
        nftNameLabel.text = nft.name
    }
    
    private func setupUI() {
        setupNFTImageView()
        setupLikeButton()
        setupNFTRatingStackView()
        setupNFTNameLabel()
        setupNFTPriceLabel()
        setupBasketButton()
    }
    
    private func setupNFTImageView() {
        contentView.addSubview(nftImageView)
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.imageHeight),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.imageWeight)
        ])
    }
    
    private func setupLikeButton() {
        contentView.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.likeImageViewInset
            ),
            likeButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.likeImageViewInset
            )
        ])
    }
    
    private func setupNFTRatingStackView() {
        contentView.addSubview(nftRatingView)
        updateRatingStarViews()
        NSLayoutConstraint.activate([
            nftRatingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftRatingView.topAnchor.constraint(
                equalTo: nftImageView.bottomAnchor,
                constant: Constants.ratingStackTopInset
            )
        ])
    }
    
    private func setupNFTNameLabel() {
        contentView.addSubview(nftNameLabel)
        NSLayoutConstraint.activate([
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftNameLabel.topAnchor.constraint(
                equalTo: nftRatingView.bottomAnchor,
                constant: Constants.nameTopInset
            )
        ])
    }
    
    private func setupNFTPriceLabel() {
        contentView.addSubview(nftPriceLabel)
        NSLayoutConstraint.activate([
            nftPriceLabel.topAnchor.constraint(
                equalTo: nftNameLabel.bottomAnchor,
                constant: Constants.priceTopInset
            ),
            nftPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    private func setupBasketButton() {
        contentView.addSubview(basketButton)
        NSLayoutConstraint.activate([
            basketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basketButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.basketBottomInset
            ),
            basketButton.heightAnchor.constraint(equalToConstant: Constants.basketHeight),
            basketButton.widthAnchor.constraint(equalToConstant: Constants.basketWidth)
        ])
    }
    
    private func updateRatingStarViews() {
        if !nftRatingView.arrangedSubviews.isEmpty {
            nftRatingView.arrangedSubviews.forEach { subView in
                nftRatingView.removeArrangedSubview(subView)
                subView.removeFromSuperview()
            }
        }
        
        for i in 1...5 {
            let raitingStar = UIImageView()
            raitingStar.image = i <= nftRating ? UIImage(named: "star") : UIImage(named: "whiteStar")
            raitingStar.contentMode = .scaleAspectFit
            nftRatingView.addArrangedSubview(raitingStar)
        }
    }
}

private enum Constants {
    static let likeImageViewInset: CGFloat = 6
    static let imageHeight: CGFloat = 110
    static let imageWeight: CGFloat = 8
    static let contentBottomInset: CGFloat = 21
    static let ratingStarsSpacing: CGFloat = 2
    static let ratingStackTopInset: CGFloat = 8
    static let nameTopInset: CGFloat = 5
    static let priceTopInset: CGFloat = 4
    static let basketBottomInset: CGFloat = 20
    static let basketWidth: CGFloat = 40
    static let basketHeight: CGFloat = 40
}
