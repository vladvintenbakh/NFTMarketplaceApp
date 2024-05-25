//
//  MyNFTTableViewCell.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.
//

import UIKit

final class MyNFTTableViewCell: UITableViewCell, ReuseIdentifying {

    // MARK: - Static Properties
    static let identifier = "MyNFTTableViewCell"

    // MARK: - Private Properties
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    } ()
    private lazy var nameView: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        return label
    } ()
    private lazy var ratingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .left
        return imageView
    } ()
    private lazy var priceNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        return label
    } ()
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        return label
    } ()

    private let cellHeight = CGFloat(140)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func setupContentView() {
        let imageContainer = setupNFTImage()
        let nameContainer = setupNameView()
        let priceContainer = setupPriceView()

        let contentStack = UIStackView(arrangedSubviews: [imageContainer, nameContainer, priceContainer])
        contentStack.axis = .horizontal
        contentStack.spacing = 10
        contentStack.distribution = .fillEqually

        contentView.addSubViews([contentStack])

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStack.heightAnchor.constraint(equalToConstant: cellHeight)
        ])
    }

    private func setupNFTImage() -> UIView {
        let view = UIView()
        let likeImage = UIImageView()
        let heartImage = UIImage(named: "likeInactive")
        likeImage.image = heartImage

        view.addSubViews([nftImageView, likeImage])
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),

            likeImage.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 12),
            likeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            likeImage.heightAnchor.constraint(equalToConstant: 16),
            likeImage.widthAnchor.constraint(equalToConstant: 18),
        ])

        return view
    }

    private func setupNameView() -> UIView {
        let view = UIView()

        let nameStack = UIStackView(arrangedSubviews: [nameView, ratingImage, authorLabel])
        nameStack.axis = .vertical
        nameStack.spacing = 5

        let view1 = UIView()
        let view2 = UIView()

        let finalStack = UIStackView(arrangedSubviews: [view1, nameStack, view2])
        finalStack.axis = .vertical
        finalStack.distribution = .equalCentering

        view.fullView(finalStack)

        return view
    }

    private func setupPriceView() -> UIView {
        let view = UIView()

        let priceLabel = UILabel()
        priceLabel.text = "Цена"
        priceLabel.font = UIFont.caption2

        let currencyLabel = UILabel()
        currencyLabel.text = "ETH"
        currencyLabel.font = UIFont.bodyBold

        let priceCurrencyStack = UIStackView(arrangedSubviews: [priceNumberLabel, currencyLabel, UIView()])
        priceCurrencyStack.axis = .horizontal
        priceCurrencyStack.spacing = 7
        priceCurrencyStack.distribution = .fill

        let priceStack = UIStackView(arrangedSubviews: [priceLabel, priceCurrencyStack])
        priceStack.axis = .vertical
        priceStack.spacing = 2

        let view1 = UIView()
        let view2 = UIView()

        let finalStack = UIStackView(arrangedSubviews: [view1, priceStack, view2])
        finalStack.axis = .vertical
        finalStack.distribution = .equalCentering

        view.fullView(finalStack)
        
        return view
    }

    // MARK: - Public Methods
    func configureCell(_ nft: NFTModel) {
        guard let imageName = nft.imageName,
              let author = nft.author,
              let rating = nft.rating else { print("Ooopsss"); return }

        nftImageView.image = UIImage(named: imageName)
        nameView.text = nft.name

        let ratingName = "rating"+"\(rating)"
        let ratingStars = UIImage(named: ratingName)
        ratingImage.image = ratingStars

        authorLabel.text = "от "+"\(author)"
        priceNumberLabel.text = nft.price
    }
}
