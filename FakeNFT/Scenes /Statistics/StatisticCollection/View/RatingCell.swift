//
//  RatingCell.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 20.05.24.
//


import UIKit

final class RatingCell: UITableViewCell {
    private lazy var subView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.segmentInactive
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Alex"
        label.font = .headline3
        return label
    }()
    
    private lazy var nftNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "112"
        label.font = .headline3
        label.textAlignment = .right
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var avatarView: UIImageView = {
        let image = UIImage(named: "Userpick")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupRatingPositionLabel()
        setupBackgroundView()
        setupAvatarImageView()
        setupUsernameLabel()
        setupNFTAmountLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBackgroundView() {
        contentView.addSubview(subView)
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: contentView.topAnchor),
            subView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            subView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.subViewInset)
        ])
    }
    
    private func setupRatingPositionLabel() {
        contentView.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingLabel.heightAnchor.constraint(equalToConstant: Constants.ratingPositionLabelHeight),
            ratingLabel.widthAnchor.constraint(equalToConstant: Constants.ratingPositionLabelWidth)
        ])
    }
    
    private func setupAvatarImageView() {
        subView.addSubview(avatarView)
        NSLayoutConstraint.activate([
            avatarView.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            avatarView.leadingAnchor.constraint(
                equalTo: subView.leadingAnchor, constant: Constants.cellElementInset
            ),
            avatarView.heightAnchor.constraint(equalToConstant: Constants.cellElementHeight),
            avatarView.widthAnchor.constraint(equalToConstant: Constants.avatarImageViewWidth)
        ])
        
        avatarView.layer.cornerRadius = 12
        avatarView.layer.masksToBounds = true
    }

    
    private func setupUsernameLabel() {
        subView.addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            usernameLabel.heightAnchor.constraint(equalToConstant: Constants.cellElementHeight)
        ])
    }
    
    private func setupNFTAmountLabel() {
        subView.addSubview(nftNumLabel)
        NSLayoutConstraint.activate([
            nftNumLabel.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            nftNumLabel.leadingAnchor.constraint(
                equalTo: usernameLabel.trailingAnchor, constant: Constants.cellElementInset),
            nftNumLabel.trailingAnchor.constraint(
                equalTo: subView.trailingAnchor, constant: -Constants.cellElementInset
            ),
            nftNumLabel.heightAnchor.constraint(equalToConstant: Constants.cellElementHeight)
        ])
    }

    func setupCell(
        user: User
    ) {
        ratingLabel.text = String(user.rating)
        avatarView.kf.setImage(with: user.avatar, placeholder: UIImage(named: "noAvatar"))
        usernameLabel.text = user.username
        nftNumLabel.text = String(user.nfts.count)
    }
}

private enum Constants {
    static let subViewInset: CGFloat = 35
    static let cellElementInset: CGFloat = 16
    static let cellElementHeight: CGFloat = 28
    static let ratingPositionLabelHeight: CGFloat = 20
    static let ratingPositionLabelWidth: CGFloat = 27
    static let avatarImageViewWidth: CGFloat = 28
}
