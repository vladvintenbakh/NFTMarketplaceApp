//
//  FavoriteNFTCollectionViewCell.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.

import UIKit
import Kingfisher

final class FavoriteNFTCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    // MARK: - Static properties
    static let identifier = "FavNFTCollectionViewCell"

    // MARK: - UI properties
    lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    } ()
    lazy var nameView: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        return label
    } ()
    lazy var ratingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .left
        return imageView
    } ()
    lazy var priceNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        return label
    } ()
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        let heartImage = UIImage(named: "likeInactive")?.withTintColor(UIColor.yaRed)
        button.setImage(heartImage, for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 18).isActive = true
        button.widthAnchor.constraint(equalToConstant: 21).isActive = true
        return button
    } ()

    // MARK: - Other properties
    let cellHeight = CGFloat(168)
    var likeButtonAction: ( () -> Void )?

    // MARK: - IB Action
    @objc func likeButtonTapped(_ sender: UIButton) {
        likeButtonAction?()
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func setupContentView() {
        let imageContainer = setupNFTImage()
        let nameContainer = setupNameView()

        let contentStack = UIStackView(arrangedSubviews: [imageContainer, nameContainer])
        contentStack.axis = .horizontal
        contentStack.spacing = 12
        contentStack.distribution = .fillEqually

        contentView.addSubViews([contentStack])

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.heightAnchor.constraint(equalToConstant: 80),
            contentStack.widthAnchor.constraint(equalToConstant: cellHeight),
        ])
    }

    private func setupNFTImage() -> UIView {
        let view = UIView()
        view.addSubViews([nftImageView, likeButton])
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 6),
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
        ])

        return view
    }

    private func setupNameView() -> UIView {
        let view = UIView()

        let currencyLabel = UILabel()
        currencyLabel.text = "ETH"
        currencyLabel.font = UIFont.caption1

        let priceCurrencyStack = UIStackView(arrangedSubviews: [priceNumberLabel, currencyLabel, UIView()])
        priceCurrencyStack.axis = .horizontal
        priceCurrencyStack.spacing = 3

        let nameStack = UIStackView(arrangedSubviews: [nameView, ratingImage, priceCurrencyStack])
        nameStack.axis = .vertical
        nameStack.spacing = 4

        let view1 = UIView()
        let view2 = UIView()

        let finalStack = UIStackView(arrangedSubviews: [view1, nameStack, view2])
        finalStack.axis = .vertical
        finalStack.distribution = .equalCentering

        view.fullView(finalStack)

        return view
    }

    // MARK: - Public methods
    func configureCell(_ nft: NFTModel) {
        guard let imageName = nft.images?.first,
              let rating = nft.rating,
              let price = nft.price else { print("Ooopsss"); return }

        let imageURL = URL(string: imageName)
        nftImageView.kf.setImage(with: imageURL)
        nameView.text = nft.name

        let ratingName = "rating"+"\(rating)"
        let ratingStars = UIImage(named: ratingName)
        ratingImage.image = ratingStars

        priceNumberLabel.text = "\(price)"
    }
}
