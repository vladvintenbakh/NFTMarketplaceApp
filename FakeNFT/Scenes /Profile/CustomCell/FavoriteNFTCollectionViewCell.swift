//
//  FavoriteNFTCollectionViewCell.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.
//

import UIKit

final class FavoriteNFTCollectionViewCell: UICollectionViewCell {

    static let identifier = "FavNFTCollectionViewCell"

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

    let cellHeight = CGFloat(168)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupContentView() {
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

    func setupNFTImage() -> UIView {
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

    func setupNameView() -> UIView {
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
}
