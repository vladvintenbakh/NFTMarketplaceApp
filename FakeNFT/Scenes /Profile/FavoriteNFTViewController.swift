//
//  FavouriteNFTViewController.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.
//

import UIKit

final class FavoriteNFTViewController: UIViewController {

    // MARK: - UI properties
    private lazy var favNFTCollection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = {
            let flow = UICollectionViewFlowLayout()
            flow.scrollDirection = .vertical
            flow.minimumLineSpacing = 20
            flow.minimumInteritemSpacing = 7
            flow.itemSize = CGSize(width: 168, height: 80)
            return flow
        } ()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(FavoriteNFTCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteNFTCollectionViewCell.identifier)
        return collection
    } ()

    // MARK: - Other properties
    var presenter: FavoriteNFTPresenter
//     var favorites = [Int]()

    // MARK: - Init
    init(presenter: FavoriteNFTPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupLayout()
    }

    // MARK: - Private properties
    private func isNeedToShowPlaceholder() {
        let favorites = presenter.mockArrayOfNFT
        if favorites.isEmpty {
            showPlaceholder()
        } else {
            favNFTCollection.isHidden = false
        }
    }

    private func showPlaceholder() {
        favNFTCollection.isHidden = true

        let placeholder = UILabel()
        placeholder.text = "У Вас ещё нет избранных NFT"
        placeholder.font = UIFont.bodyBold
        view.centerView(placeholder)
    }

    private func setupNavigation() {
        title = "Избранные NFT"

        // Убираем тут Back в стрелке обратно
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.black
    }

    private func setupLayout() {
        view.backgroundColor = UIColor.background

        view.addSubViews([favNFTCollection])

        NSLayoutConstraint.activate([
            favNFTCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            favNFTCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            favNFTCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favNFTCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FavoriteNFTViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getNumberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteNFTCollectionViewCell.identifier, for: indexPath) as? FavoriteNFTCollectionViewCell else { return UICollectionViewCell()}
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    private func configureCell(cell: FavoriteNFTCollectionViewCell, indexPath: IndexPath) {
        let nft = presenter.mockArrayOfNFT[indexPath.row]
        guard let imageName = nft.imageName,
              let rating = nft.rating else { print("Ooopsss"); return }

        cell.nftImageView.image = UIImage(named: imageName)
        cell.nameView.text = nft.name

        let ratingName = "rating"+"\(rating)"
        let ratingImage = UIImage(named: ratingName)
        cell.ratingImage.image = ratingImage

        cell.priceNumberLabel.text = nft.price
    }
}
