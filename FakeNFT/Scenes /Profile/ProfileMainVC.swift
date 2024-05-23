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
        table.layoutMargins = .zero
        return table
    } ()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.AppFonts.bold22
        return label
    } ()
    private lazy var photoImage: UIImageView = {
        let imagePhotoView = UIImageView()
        let imageSize = CGFloat(70)
        imagePhotoView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        imagePhotoView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imagePhotoView.round(squareSize: imageSize)
        imagePhotoView.layer.borderWidth = 0.5
        return imagePhotoView
    } ()
    private lazy var aboutMeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Constants.AppFonts.regular13
        return label
    } ()
    private lazy var webSiteLabel: UILabel = {
        let label = UILabel()
//        label.text = "Joaquin Phoenix.com"
        label.font = Constants.AppFonts.regular15
        label.textColor = Constants.AppColors.appBlue
        return label
    } ()

    // MARK: - Other Properties
    let networkManager = NetworkManager()
    let progressIndicator = ProgressIndicator()
    var delegate: ProfileViewControllerDelegate?

    var count = 0
    var apiData: ApiModel?

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        getDataFromNetwork()
    }

    // MARK: - IB Actions
    @objc private func editButtonTapped(sender: UIButton) {
        let vc = EditProfileViewController()
        let EditVC = UINavigationController(rootViewController: vc)
        present(EditVC, animated: true)
    }

    // MARK: - Private methods
    private func getDataFromNetwork() {
        fetchDataFromNetwork()
        progressIndicator.show()
        networkManager.dataUpdated = { [weak self] in
            guard let self else { return }
            updateData()
            updateUI()
            progressIndicator.succeed()
        }
    }

    private func fetchDataFromNetwork() {
        networkManager.performRequest()
    }

    private func updateData() {
        apiData = networkManager.decodedData
    }

    private func updateUI() {
        guard let data = apiData,
              let nfts = data.nfts else { return }
        DispatchQueue.main.async {
            self.nameLabel.text = data.name
            let imageURL = self.networkManager.profileImageURL
            self.photoImage.kf.setImage(with: imageURL)
            self.aboutMeLabel.text = data.description
            self.webSiteLabel.text = data.website
            self.count = nfts.count
            self.nftTable.reloadData()
        }
    }

    private func setupLayout() {
        view.backgroundColor = Constants.AppColors.appBackground

        setupNavigation()

        setupContentStack()
    }

    private func setupNavigation() {
        let editImage = UIImage(systemName: "square.and.pencil")
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let boldImage = editImage?.withConfiguration(symbolConfiguration)
        let colorImage = boldImage?.withTintColor(Constants.AppColors.appBlack, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: colorImage, landscapeImagePhone: nil, style: .done, target: self, action: #selector(editButtonTapped))
    }

    private func setupContentStack() {
        let photoAndNameStack = setupPersonalDataStack()

        let stack = UIStackView(arrangedSubviews: [photoAndNameStack, nftTable])
        stack.axis = .vertical
        stack.spacing = 40

        view.addSubViews([stack])

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
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
        cell.textLabel?.font = Constants.AppFonts.bold17
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
        let vc = MyNFTViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func goToFavNFTScreen() {
        let vc = FavoriteNFTViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func goToWebScreen() {
        let vc = WebViewController()
        self.delegate = vc
        delegate?.passWebsiteName(webSiteLabel.text)
        navigationController?.pushViewController(vc, animated: true)
    }
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
            return ProfileMainVC()
        }

        typealias UIViewControllerType = UIViewController


        let viewController = ProfileMainVC()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProviderProfile.ContainterView>) -> ProfileMainVC {
            return viewController
        }

        func updateUIViewController(_ uiViewController: ProviderProfile.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProviderProfile.ContainterView>) {

        }
    }
}
