//
//  PaymentTableViewCell.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

final class PaymentTableViewCell: UITableViewCell {
    static let identifier = "PaymentTableViewCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .yaLightGrayLight
        layer.cornerRadius = 16
        
        addSubviews()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Layout
extension PaymentTableViewCell {
    private func addSubviews() {
        let subviews = [iconImage, currencyNameLabel, currencyCodeLabel]
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(item)
        }
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            iconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImage.heightAnchor.constraint(equalToConstant: 36),
            iconImage.widthAnchor.constraint(equalToConstant: 36),
            
            currencyNameLabel.leadingAnchor.constraint(equalTo: iconImage.leadingAnchor, constant: 4),
            currencyNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            currencyCodeLabel.leadingAnchor.constraint(equalTo: currencyNameLabel.leadingAnchor),
            currencyCodeLabel.topAnchor.constraint(equalTo: currencyNameLabel.bottomAnchor)
        ])
    }
}
