//
//  StatisticProfileVC.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 23.05.24.
//

import UIKit

protocol UserInfoViewProtocol: AnyObject {
    func updateUserInfo(username: String, description: String, avatar: UIImage?)
}

final class StatisticProfileVC: UIViewController, UserInfoViewProtocol {
    var presenter: UserInfoPresenterProtocol!

    private lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.segmentActive
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var profileDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.segmentActive
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var profileWebsiteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.segmentActive.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(UIColor.segmentActive, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.backgroundColor = UIColor.yaWhiteLight
        return button
    }()

    private lazy var nftCollectionButtonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Коллекция NFT (112)"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .segmentActive
        return label
    }()

    private lazy var nftCollectionButtonImageView: UIImageView = {
        let image = UIImage(named: "forward")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nftCollectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapNFTCollection), for: .touchUpInside)
        return button
    }()

    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        profileNameLabel.text = user.username
        profileDescription.text = user.description
        avatarImageView.image = user.avatar
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yaWhiteLight

        setupUI()
        presenter.viewDidLoad()
    }

    @objc private func didTapNFTCollection() {
        presenter.nftCollectionButtonDidTap()
    }

    private func setupUI() {
        setupNavBar()
        setupAvatarImageView()
        setupUsernameLabel()
        setupUserDescription()
        setupUserWebsiteButton()
        setupNFTCollectionButton()
    }

    func updateUserInfo(username: String, description: String, avatar: UIImage?) {
        profileNameLabel.text = username
        profileDescription.text = description
        avatarImageView.image = avatar
    }

    private func setupUsernameLabel() {
        view.addSubview(profileNameLabel)
        NSLayoutConstraint.activate([
            profileNameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: Constants.defaultInset
            ),
            profileNameLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.defaultInset
            ),
            profileNameLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.defaultElementSpacing
            )
        ])
    }

    private func setupUserDescription() {
        view.addSubview(profileDescription)
        NSLayoutConstraint.activate([
            profileDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultInset),
            profileDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultInset),
            profileDescription.topAnchor.constraint(
                equalTo: profileNameLabel.bottomAnchor,
                constant: Constants.defaultElementSpacing
            )
        ])
    }

    private func setupNavBar() {
        let backButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        backButton.tintColor = UIColor.segmentActive
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    private func setupAvatarImageView() {
        view.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.userAvatarHeight),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.userAvatarWidth),
            avatarImageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.defaultInset
            ),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    private func setupUserWebsiteButton() {
        view.addSubview(profileWebsiteButton)
        NSLayoutConstraint.activate([
            profileWebsiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultInset),
            profileWebsiteButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.defaultInset
            ),
            profileWebsiteButton.topAnchor.constraint(equalTo: profileDescription.bottomAnchor, constant: 28),
            profileWebsiteButton.heightAnchor.constraint(equalToConstant: Constants.userWebsiteButtonHeight)
        ])
    }

    private func setupNFTCollectionButton() {
        view.addSubview(nftCollectionButton)
        nftCollectionButton.addSubview(nftCollectionButtonLabel)
        nftCollectionButton.addSubview(nftCollectionButtonImageView)

        NSLayoutConstraint.activate([
            nftCollectionButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.defaultInset
            ),
            nftCollectionButton.topAnchor.constraint(
                equalTo: profileWebsiteButton.bottomAnchor,
                constant: Constants.defaultElementSpacing
            ),
            nftCollectionButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.defaultInset)
        ])

        NSLayoutConstraint.activate([
            nftCollectionButtonLabel.leadingAnchor.constraint(equalTo: nftCollectionButton.leadingAnchor),
            nftCollectionButtonLabel.centerYAnchor.constraint(equalTo: nftCollectionButton.centerYAnchor),

            nftCollectionButtonImageView.trailingAnchor.constraint(equalTo: nftCollectionButton.trailingAnchor),
            nftCollectionButtonImageView.centerYAnchor.constraint(equalTo: nftCollectionButton.centerYAnchor)
        ])
    }
}

private enum Constants {
    static let userAvatarHeight: CGFloat = 70
    static let userAvatarWidth: CGFloat = 70
    static let defaultInset: CGFloat = 16
    static let defaultElementSpacing: CGFloat = 40
    static let userWebsiteButtonHeight: CGFloat = 40
}
