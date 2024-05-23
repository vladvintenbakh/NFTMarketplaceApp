//
//  MyNFTTableViewCell.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.
//

import UIKit

final class MyNFTTableViewCell: UITableViewCell {

    static let identifier = "MyNFTTableViewCell"

    lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
        label.font = UIFont.bodyBold
        return label
    } ()
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        return label
    } ()

    let cellHeight = CGFloat(140)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupContentView() {
        let view1 = setupNFTImage()
        let view2 = setupNameView()
        let view3 = setupPriceView()

        let contentStack = UIStackView(arrangedSubviews: [view1, view2, view3])
        contentStack.axis = .horizontal
        contentStack.spacing = 20
        contentStack.distribution = .fillEqually

        contentView.addSubViews([contentStack])

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStack.heightAnchor.constraint(equalToConstant: cellHeight)
        ])
    }

    func setupNFTImage() -> UIView {
        let view = UIView()

        view.addSubViews([nftImageView])
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])

        return view
    }

    func setupNameView() -> UIView {
        let view = UIView()

        let nameStack = UIStackView(arrangedSubviews: [nameView, ratingImage, authorLabel])
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

    func setupPriceView() -> UIView {
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
}
