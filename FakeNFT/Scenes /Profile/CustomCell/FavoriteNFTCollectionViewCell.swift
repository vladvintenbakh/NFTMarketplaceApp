//
//  FavoriteNFTCollectionViewCell.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.
//

import UIKit

final class FavoriteNFTCollectionViewCell: UICollectionViewCell {

    static let identifier = "FavNFTCollectionViewCell"

    var stack = UIStackView()
    let nftImageView = UIImageView()
    let nameView = UILabel()
    let priceView = UIView()

    let cellHeight = CGFloat(168)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupContentView() {
        let view1 = setupNFTImage()
        let view2 = setupNameView()

        stack = UIStackView(arrangedSubviews: [view1, view2])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillEqually

        contentView.addSubViews([stack])

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.heightAnchor.constraint(equalToConstant: 80),
            stack.widthAnchor.constraint(equalToConstant: 168),
        ])
    }

    func setupNFTImage() -> UIView {
        let view = UIView()
        let nftImage = UIImage(named: "NFT card")
        let imageView = UIImageView(image: nftImage)
        view.fullView(imageView)
        return view
    }

    func setupNameView() -> UIView {
        let view = UIView()

        nameView.text = "Lilo"
        nameView.font = UIFont.bodyBold

        let starImage = UIImageView(image: UIImage(named: "rating1"))
        starImage.contentMode = .left

        let priceNumberLabel = UILabel()
        priceNumberLabel.text = "1,78 ETH"
        priceNumberLabel.font = UIFont.caption1

        let nameStack = UIStackView(arrangedSubviews: [nameView, starImage, priceNumberLabel])
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
