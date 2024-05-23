//
//  PaymentCollectionViewCell.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

final class PaymentCollectionViewCell: UICollectionViewCell {
    static let identifier = "PaymentCollectionViewCell"
    
    private let grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .yaLightGrayLight
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let iconImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 6
        return image
    }()
    
    private let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yaBlackLight
        label.font = .caption2
        return label
    }()
    
    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yaGreen
        label.font = .caption2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Layout
extension PaymentCollectionViewCell {
    private func addSubviews() {
        let wrapperSubviews = [iconImage, currencyNameLabel, currencyCodeLabel]
        wrapperSubviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            grayBackgroundView.addSubview(item)
        }
        
        grayBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(grayBackgroundView)
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            grayBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            grayBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            grayBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            grayBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImage.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor, constant: 12),
            iconImage.centerYAnchor.constraint(equalTo: grayBackgroundView.centerYAnchor),
            iconImage.heightAnchor.constraint(equalToConstant: 36),
            iconImage.widthAnchor.constraint(equalToConstant: 36),
            
            currencyNameLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 4),
            currencyNameLabel.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor, constant: -12),
            currencyNameLabel.topAnchor.constraint(equalTo: grayBackgroundView.topAnchor, constant: 5),
            
            currencyCodeLabel.leadingAnchor.constraint(equalTo: currencyNameLabel.leadingAnchor),
            currencyCodeLabel.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor, constant: -12),
            currencyCodeLabel.bottomAnchor.constraint(equalTo: grayBackgroundView.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: Dynamic UI Configuration
extension PaymentCollectionViewCell {
    func setImage(_ image: UIImage) {
        iconImage.image = image
    }
    
    func setCurrencyName(_ name: String) {
        currencyNameLabel.text = name
    }
    
    func setCurrencyCode(_ code: String) {
        currencyCodeLabel.text = code
    }
}
