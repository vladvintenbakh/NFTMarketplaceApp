//
//  MyNFTViewController.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.
//

import UIKit

protocol MyNFTViewProtocol: AnyObject {
    func showPlaceholder()
    func hideTableView()
    func showAlert()
    func updateTableView()
}

final class MyNFTViewController: UIViewController {

    // MARK: - UI properties
    private lazy var myNFTTable: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(MyNFTTableViewCell.self)
        table.separatorStyle = .none
        table.allowsSelection = false
        return table
    } ()

    // MARK: - Other properties
    var presenter: MyNFTPresenterProtocol

    private let cellHeight = CGFloat(140)
    private let tableConstraints = CGFloat(20)

    // MARK: - Init
    init(presenter: MyNFTPresenterProtocol) {
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

    // MARK: - IB Action
    @objc private func sortButtonTapped(sender: UIButton) {
        presenter.sortButtonTapped()
    }

    // MARK: - Public Methods
    func showPlaceholder() {
        myNFTTable.isHidden = true

        let placeholder = UILabel()
        placeholder.text = "У Вас ещё нет NFT"
        placeholder.font = UIFont.bodyBold
        view.centerView(placeholder)
    }

    func hideTableView() {
        myNFTTable.isHidden = false
    }

    func showAlert() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))

        alert.addAction(UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.priceSorting()
        })

        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.ratingSorting()
        })

        alert.addAction(UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.nameSorting()
        })

        present(alert, animated: true)
    }

    func updateTableView() {
        myNFTTable.reloadData()
    }

    // MARK: - Private Methods
    private func setupLayout() {
        setupNavigation()
        view.backgroundColor = UIColor.background

        view.addSubViews([myNFTTable])

        NSLayoutConstraint.activate([
            myNFTTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: tableConstraints),
            myNFTTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tableConstraints),
            myNFTTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tableConstraints),
            myNFTTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -tableConstraints)
        ])
    }

    private func setupNavigation() {
        title = "Мои NFT"

        // Убираем тут Back в стрелке обратно
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.black

        // Добавляем кнопку справа
        let image = UIImage(named: "CartSortIcon")?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(sortButtonTapped))
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyNFTViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTTableViewCell.identifier) as? MyNFTTableViewCell else { print("Issue with cell"); return UITableViewCell() }

        let nft = presenter.getNFT(with: indexPath)
        let isNFTFav = presenter.isNFTInFav(nft)

        cell.configureCell(nft, isNFTFav: isNFTFav)
        addOrRemoveNFTFromFav(cell: cell, nft: nft, isNFTInFav: isNFTFav)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }

    private func addOrRemoveNFTFromFav(cell: MyNFTTableViewCell, nft: NFTModel, isNFTInFav: Bool) {
        cell.likeButtonAction = { [weak self] in
            guard let self = self else { return }
            self.presenter.addOrRemoveNFTFromFav(nft: nft, isNFTFav: isNFTInFav)

            DispatchQueue.main.async {
                self.myNFTTable.reloadData()
            }
        }
    }
}

// MARK: - MyNFTViewProtocol
extension MyNFTViewController: MyNFTViewProtocol {

}
