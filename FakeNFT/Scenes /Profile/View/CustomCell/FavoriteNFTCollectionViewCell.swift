//
//  FavoriteNFTCollectionViewCell.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.

import UIKit

final class FavoriteNFTCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    // MARK: - Static properties
    static let identifier = "FavNFTCollectionViewCell"

    // MARK: - UI properties
    lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
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

    // MARK: - Other properties
    let cellHeight = CGFloat(168)

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
        let likeImage = UIImageView()
        let heartImage = UIImage(named: "likeInactive")?.withTintColor(UIColor.yaRed)
        likeImage.image = heartImage

        view.addSubViews([nftImageView, likeImage])
        NSLayoutConstraint.activate([
            likeImage.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 6),
            likeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            likeImage.heightAnchor.constraint(equalToConstant: 18),
            likeImage.widthAnchor.constraint(equalToConstant: 21),
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
        priceCurrencyStack.spacing = 5

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
        guard let imageName = nft.imageName,
              let rating = nft.rating else { print("Ooopsss"); return }

        nftImageView.image = UIImage(named: imageName)
        nameView.text = nft.name

        let ratingName = "rating"+"\(rating)"
        let ratingStars = UIImage(named: ratingName)
        ratingImage.image = ratingStars

        priceNumberLabel.text = nft.price
    }
}
