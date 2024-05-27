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
        imageView.setSquareSize(108)
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
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        let heartImage = UIImage(named: "likeInactive")
        button.setImage(heartImage, for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 16).isActive = true
        button.widthAnchor.constraint(equalToConstant: 18).isActive = true
        return button
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

    // MARK: - IB Action
    @objc func likeButtonTapped(_ sender: UIButton) {
        print("likeButtonTapped")
    }

    // MARK: - Private Methods
    private func setupContentView() {
        let nameContainer = setupNameView()
        let priceContainer = setupPriceView()

        let contentStack = UIStackView(arrangedSubviews: [nftImageView, nameContainer, priceContainer])
        contentStack.axis = .horizontal
        contentStack.spacing = 20

        contentView.addSubViews([contentStack, likeButton])

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 12),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -12),
        ])
    }

    private func setupNameView() -> UIView {
        let view = UIView()

        let nameStack = UIStackView(arrangedSubviews: [nameView, ratingImage, authorLabel])
        nameStack.axis = .vertical
        nameStack.spacing = 5

        view.addSubViews([nameStack])
        NSLayoutConstraint.activate([
            nameStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nameStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

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

        view.addSubViews([priceStack])
        NSLayoutConstraint.activate([
            priceStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            priceStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

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
