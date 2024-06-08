//
//  FavouriteNFTViewController.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.
//

import UIKit

protocol FavoriteNFTViewProtocol: AnyObject {
    func showPlaceholder()
    func hideCollection()
    func updateUI()
}

final class FavoriteNFTViewController: UIViewController {

    // MARK: - UI properties
    private lazy var favNFTCollection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = {
            let flow = UICollectionViewFlowLayout()
            flow.scrollDirection = .vertical
            flow.minimumLineSpacing = 20
            flow.minimumInteritemSpacing = 5
            let width = (view.bounds.width - 32 - 5) / 2
            flow.itemSize = CGSize(width: width, height: 80)
            return flow
        } ()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(FavoriteNFTCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteNFTCollectionViewCell.identifier)
        collection.backgroundColor = .clear
        return collection
    } ()
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Other properties
    var presenter: FavoriteNFTPresenterProtocol

    // MARK: - Init
    init(presenter: FavoriteNFTPresenterProtocol) {
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
        presenter.viewDidLoad()
    }

    // MARK: - Public properties
    func showPlaceholder() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.favNFTCollection.isHidden = true

            let placeholder = UILabel()
            placeholder.text = "У Вас ещё нет избранных NFT"
            placeholder.font = UIFont.bodyBold
            self.view.centerView(placeholder)
        }
    }

    func hideCollection() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.favNFTCollection.isHidden = false
        }
    }

    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.favNFTCollection.reloadData()
        }
    }

    // MARK: - Private properties
    private func setupLayout() {
        setupNavigation()
        setupSearchController()

        view.backgroundColor = UIColor.backgroundActive

        view.addSubViews([favNFTCollection])

        NSLayoutConstraint.activate([
            favNFTCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            favNFTCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favNFTCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favNFTCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupNavigation() {
        title = SGen.favoritesNFT
        // Убираем тут Back в стрелке обратно
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.segmentActive
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FavoriteNFTViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getNumberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteNFTCollectionViewCell.identifier, for: indexPath) as? FavoriteNFTCollectionViewCell  else {
            print("Issue with CollectionCell"); return UICollectionViewCell()}
        cell.backgroundColor = .clear
        let nft = presenter.getFavNFT(indexPath: indexPath)
        cell.configureCell(nft)
        removeNFTFromFav(cell: cell, nft: nft)

        return cell
    }

    private func removeNFTFromFav(cell: FavoriteNFTCollectionViewCell, nft: NFTModelData) {
        cell.likeButtonAction = { [weak self] in
            guard let self = self else { return }
            self.presenter.removeNFTFromFav(nft)
        }
    }
}

// MARK: - FavoriteNFTViewProtocol
extension FavoriteNFTViewController: FavoriteNFTViewProtocol {

}

// MARK: - UISearchResultsUpdating
extension FavoriteNFTViewController: UISearchResultsUpdating {

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text?.lowercased() else { return }
        presenter.filterData(searchBarText)
        favNFTCollection.reloadData()
    }
}
