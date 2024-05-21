//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Александр Гегешидзе on 20.05.2024.
//

import UIKit

final class CatalogCell: UITableViewCell {
    
    // MARK: - Stored properties
    
    static let reuseIdentifier = "CatalogCell"
    
    //MARK: - Layout variables
    
    private lazy var catalogImageView: UIImageView = {
        let image = UIImage(named: "Cover1.png")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .top
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.text = "Peach (10)"
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    func configureCell() {
        contentView.backgroundColor = .ypWhiteDay
        addSubViews()
        applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateImageSize()
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        [catalogImageView, footerLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            catalogImageView.heightAnchor.constraint(equalToConstant: 140),
            catalogImageView.widthAnchor.constraint(equalToConstant: 343),
            catalogImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            catalogImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            catalogImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            footerLabel.leadingAnchor.constraint(equalTo: catalogImageView.leadingAnchor),
            footerLabel.topAnchor.constraint(equalTo: catalogImageView.bottomAnchor, constant: 4),
            footerLabel.trailingAnchor.constraint(equalTo: catalogImageView.trailingAnchor),
            footerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
        ])
    }
    
    private func updateImageSize() {
        guard let originalImage = catalogImageView.image else {
            return
        }
        
        let imageViewWidth = catalogImageView.bounds.width
        let scale = imageViewWidth / originalImage.size.width
        let newImageHeight = originalImage.size.height * scale
        
        let newSize = CGSize(width: imageViewWidth, height: newImageHeight)
        if let resizedImage = originalImage.resized(to: newSize) {
            catalogImageView.image = resizedImage
        }
    }
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
