//
//  FavouriteNFTViewController.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.
//

import UIKit

protocol FavoriteNFTViewProtocol: AnyObject {

}

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
    var presenter: FavoriteNFTPresenterProtocol?

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        showOrHidePlaceholder()
    }

    // MARK: - Private properties
    private func showOrHidePlaceholder() {
        guard let favorites = presenter?.mockArrayOfNFT else { print("Oops"); return }
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

    private func setupLayout() {
        setupNavigation()

        view.backgroundColor = UIColor.background

        view.addSubViews([favNFTCollection])

        NSLayoutConstraint.activate([
            favNFTCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            favNFTCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            favNFTCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favNFTCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupNavigation() {
        title = "Избранные NFT"
        // Убираем тут Back в стрелке обратно
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.black
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FavoriteNFTViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.getNumberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteNFTCollectionViewCell.identifier, for: indexPath) as? FavoriteNFTCollectionViewCell,
              let nft = presenter?.mockArrayOfNFT[indexPath.row] else { print("Issue with CollectionCell"); return UICollectionViewCell()}

        cell.configureCell(nft)
        removeNFTFromFav(cell: cell, nft: nft)

        return cell
    }

    private func removeNFTFromFav(cell: FavoriteNFTCollectionViewCell, nft: NFTModel) {
        cell.likeButtonAction = { [weak self] in
            guard let self = self else { return }
            self.presenter?.removeNFTFromFav(nft)
            self.updateUI()
        }
    }

    private func updateUI() {
        presenter?.uploadDataFromStorage()
        
        DispatchQueue.main.async {
            self.favNFTCollection.reloadData()
        }
    }
}

extension FavoriteNFTViewController: FavoriteNFTViewProtocol {

}
