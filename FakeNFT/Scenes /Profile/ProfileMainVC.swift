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

    //    let networkManager = NetworkManager()
    //    let progressIndicator = ProgressIndicator()
    //    var delegate: ProfileViewControllerDelegate?

        var count = 0
    //    var apiData: ApiModel?

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
//        getDataFromNetwork()
    }

    // MARK: - IB Actions
    @objc private func editButtonTapped(sender: UIButton) {
//        let vc = EditProfileViewController()
//        let EditVC = UINavigationController(rootViewController: vc)
//        present(EditVC, animated: true)
    }

    // MARK: - Private methods
//    private func getDataFromNetwork() {
//        fetchDataFromNetwork()
//        progressIndicator.show()
//        networkManager.dataUpdated = { [weak self] in
//            guard let self else { return }
//            updateData()
//            updateUI()
//            progressIndicator.succeed()
//        }
//    }

//    private func fetchDataFromNetwork() {
//        networkManager.performRequest()
//    }

//    private func updateData() {
//        apiData = networkManager.decodedData
//    }

//    private func updateUI() {
//        guard let data = apiData,
//              let nfts = data.nfts else { return }
//        DispatchQueue.main.async {
//            self.nameLabel.text = data.name
//            let imageURL = self.networkManager.profileImageURL
//            self.photoImage.kf.setImage(with: imageURL)
//            self.aboutMeLabel.text = data.description
//            self.webSiteLabel.text = data.website
//            self.count = nfts.count
//            self.nftTable.reloadData()
//        }
//    }


    private func updateUIWithMockData() {
        guard let data = presenter?.mockData,
              let imageName = data.avatar,
              let nftList = data.nfts else { return }

        nameLabel.text = data.name
        let image =  UIImage(named: imageName)
        photoImage.image = image
        aboutMeLabel.text = data.description
        webSiteLabel.text = data.website
        count = nftList.count
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
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        let rowNames = ["Мои NFT", "Избранные NFT", "О разработчике"]
        let name = rowNames[indexPath.row]
        if name == rowNames.first {
            cell.textLabel?.text = "\(name) (\(count))"
        } else {
            cell.textLabel?.text = "\(name)"
        }
        cell.textLabel?.font = UIFont.bodyBold
        let disclosureImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 12))
        disclosureImage.image = UIImage(named: "chevron")
        cell.accessoryView = disclosureImage
        cell.selectionStyle = .none
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: goToMyNFTScreen()
        case 1: goToFavNFTScreen()
        default: goToWebScreen()
        }
    }

    private func goToMyNFTScreen() {
//        let vc = MyNFTViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }

    private func goToFavNFTScreen() {
//        let vc = FavoriteNFTViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }

    private func goToWebScreen() {
//        let vc = WebViewController()
//        self.delegate = vc
//        delegate?.passWebsiteName(webSiteLabel.text)
//        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - SwiftUI
import SwiftUI
struct ProviderProfile : PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }

    struct ContainterView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return ProfileMainVC(presenter: ProfilePresenter())
        }

        typealias UIViewControllerType = UIViewController


        let viewController = ProfileMainVC(presenter: ProfilePresenter())
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProviderProfile.ContainterView>) -> ProfileMainVC {
            return viewController
        }

        func updateUIViewController(_ uiViewController: ProviderProfile.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProviderProfile.ContainterView>) {

        }
    }
}
