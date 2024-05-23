//
//  ProfileMainVC.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 19/5/24.
//

import UIKit

final class ProfileMainVC: UIViewController {

    // MARK: - UI Properties
    private lazy var nftTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.separatorInset = .zero
        return table
    } ()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        return label
    } ()
    private lazy var photoImage: UIImageView = {
        let imagePhotoView = UIImageView()
        let imageSize = CGFloat(70)
        imagePhotoView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        imagePhotoView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imagePhotoView.contentMode = .scaleAspectFit
        imagePhotoView.round(squareSize: imageSize)
        return imagePhotoView
    } ()
    private lazy var aboutMeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.caption2
        return label
    } ()
    private lazy var webSiteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = UIColor.yaBlue
        return label
    } ()

    // MARK: - Other Properties
    let presenter: ProfilePresenterProtocol?
    var delegate: ProfileViewControllerDelegate?

    let rowNames = ["Мои NFT", "Избранные NFT", "О разработчике"]
    var count = 0
    var favoriteNFT = 0

    // MARK: - Init
    init(presenter: ProfilePresenterProtocol?) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        updateUIWithMockData()
    }

    // MARK: - IB Actions
    @objc private func editButtonTapped(sender: UIButton) {
        let vc = EditProfileViewController()
        let EditVC = UINavigationController(rootViewController: vc)
        present(EditVC, animated: true)
    }

    // MARK: - Private methods
    private func updateUIWithMockData() {
        guard let data = presenter?.mockData,
              let imageName = data.avatar,
              let nftList = data.nfts,
              let favList = data.favoriteNFT else { return }

        nameLabel.text = data.name
        let image =  UIImage(named: imageName)
        photoImage.image = image
        aboutMeLabel.text = data.description
        webSiteLabel.text = data.website
        count = nftList.count
        favoriteNFT = favList.count
    }

    private func setupLayout() {
        view.backgroundColor = UIColor.background

        setupNavigation()

        setupContentStack()
    }

    private func setupNavigation() {
        let editImage = UIImage(systemName: "square.and.pencil")
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let boldImage = editImage?.withConfiguration(symbolConfiguration)
        let colorImage = boldImage?.withTintColor(UIColor.yaBlackLight, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: colorImage, landscapeImagePhone: nil, style: .done, target: self, action: #selector(editButtonTapped))
    }

    private func setupContentStack() {
        let photoAndNameStack = setupPersonalDataStack()

        view.addSubViews([photoAndNameStack, nftTable])

        NSLayoutConstraint.activate([
            photoAndNameStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            photoAndNameStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photoAndNameStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            nftTable.topAnchor.constraint(equalTo: photoAndNameStack.bottomAnchor, constant: 40),
            nftTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            nftTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            nftTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupPersonalDataStack() -> UIStackView {

        let photoStack = UIStackView(arrangedSubviews: [photoImage, nameLabel])
        photoStack.axis = .horizontal
        photoStack.spacing = 16

        let dataStack = UIStackView(arrangedSubviews: [photoStack, aboutMeLabel, webSiteLabel])
        dataStack.axis = .vertical
        dataStack.distribution = .equalCentering

        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: photoStack.bottomAnchor, constant: 20),
            webSiteLabel.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 8),
        ])

        return dataStack
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProfileMainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rowNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        fillInCellName(cell: cell, indexPath: indexPath)
        cell.textLabel?.font = UIFont.bodyBold
        let disclosureImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 12))
        disclosureImage.image = UIImage(named: "chevron")
        cell.accessoryView = disclosureImage
        cell.selectionStyle = .none
    }

    private func fillInCellName(cell: UITableViewCell, indexPath: IndexPath) {
        let name = rowNames[indexPath.row]
        
        switch name {
        case "Мои NFT": cell.textLabel?.text = "\(name) (\(count))"
        case "Избранные NFT": cell.textLabel?.text = "\(name) (\(favoriteNFT))"
        default: cell.textLabel?.text = "\(name)"
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: goToMyNFTScreen()
        case 1: goToFavNFTScreen()
        default: goToWebScreen()
        }
    }

    private func goToMyNFTScreen() {
        let presenter = MyNFTPresenter()
        let vc = MyNFTViewController(presenter: presenter)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func goToFavNFTScreen() {
        let presenter = FavoriteNFTPresenter()
        let vc = FavoriteNFTViewController(presenter: presenter)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func goToWebScreen() {
        let presenter = WebViewPresenter()
        self.delegate = presenter
        let vc = WebViewController(presenter: presenter)
        delegate?.passWebsiteName(webSiteLabel.text)
        navigationController?.pushViewController(vc, animated: true)
    }
}
