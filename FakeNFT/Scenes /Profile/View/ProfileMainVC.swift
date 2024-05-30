//
//  ProfileMainVC.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 19/5/24.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    func updateUIWithMockData(_ data: ProfileMockModel)
}

final class ProfileMainVC: UIViewController {

    // MARK: - UI Properties
    private lazy var nftTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.separatorInset = .zero
        table.backgroundColor = .clear
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
    private lazy var webButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.yaBlue, for: .normal)
        button.titleLabel?.font = UIFont.caption1
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(webSiteButtonTapped), for: .touchUpInside)
        return button
    } ()

    // MARK: - Other Properties
    var presenter: ProfilePresenterProtocol
    let notification = NotificationCenter.default

    // MARK: - Init
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
           notification.removeObserver(self)
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        presenter.viewDidLoad()
        addObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter.viewDidLoad()

        DispatchQueue.main.async { [weak self] in
            self?.nftTable.reloadData()
        }
    }

    // MARK: - IB Actions
    @objc private func editButtonTapped(sender: UIButton) {
        presenter.editButtonTapped()
    }

    @objc private func webSiteButtonTapped(sender: UIButton) {
        presenter.webSiteButtonTapped()
    }


    // MARK: - Public methods
    func updateUIWithMockData(_ data: ProfileMockModel) {
        nameLabel.text = data.name
        guard let imageName = data.avatar else { return }
        let image = UIImage(named: imageName)
        photoImage.image = image
        aboutMeLabel.text = data.description
        webButton.setTitle(data.website, for: .normal)
    }

    // MARK: - Private methods
    private func setupLayout() {
        setupNavigation()
        setupContentStack()
    }

    private func setupNavigation() {
        let editImage = UIImage(systemName: "square.and.pencil")
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let boldImage = editImage?.withConfiguration(symbolConfiguration)
        let colorImage = boldImage?.withTintColor(UIColor.segmentActive, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: colorImage, landscapeImagePhone: nil, style: .done, target: self, action: #selector(editButtonTapped))
    }

    private func setupContentStack() {
        view.backgroundColor = UIColor.backgroundActive

        let photoAndNameStack = setupPersonalDataStack()

        view.addSubViews([photoAndNameStack, nftTable])

        NSLayoutConstraint.activate([
            photoAndNameStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            photoAndNameStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photoAndNameStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            nftTable.topAnchor.constraint(equalTo: photoAndNameStack.bottomAnchor, constant: 40),
            nftTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupPersonalDataStack() -> UIStackView {

        let photoStack = UIStackView(arrangedSubviews: [photoImage, nameLabel])
        photoStack.axis = .horizontal
        photoStack.spacing = 16

        let dataStack = UIStackView(arrangedSubviews: [photoStack, aboutMeLabel, webButton])
        dataStack.axis = .vertical
        dataStack.distribution = .equalCentering

        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: photoStack.bottomAnchor, constant: 20),
            webButton.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 8),

//            webSiteLabel.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 8),
        ])

        return dataStack
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProfileMainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getRowCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }

        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        fillInCellName(cell: cell, indexPath: indexPath)
        cell.backgroundColor = .clear

        cell.textLabel?.font = UIFont.bodyBold
        let disclosureImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 12))
        disclosureImage.image = UIImage(named: "chevron")?.withTintColor(UIColor.segmentActive)
        cell.accessoryView = disclosureImage
        cell.selectionStyle = .none
    }

    private func fillInCellName(cell: UITableViewCell, indexPath: IndexPath) {
        let nameAndCount = presenter.nameCell(indexPath: indexPath)
        cell.textLabel?.text = nameAndCount
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectCell(indexPath: indexPath)
    }
}

// MARK: - Notification
extension ProfileMainVC {
    private func addObserver() {
        notification.addObserver(forName: .profileDidChange, object: nil, queue: .main) { [weak self] notification in
            self?.presenter.viewDidLoad()
        }
    }
}

// MARK: - ProfileViewProtocol
extension ProfileMainVC: ProfileViewProtocol {

}
