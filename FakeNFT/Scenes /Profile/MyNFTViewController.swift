//
//  MyNFTViewController.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.
//

import UIKit

final class MyNFTViewController: UIViewController {

    // MARK: - UI properties
    private lazy var myNFTTable: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(MyNFTTableViewCell.self, forCellReuseIdentifier: MyNFTTableViewCell.identifier)
        table.separatorStyle = .none
        table.allowsSelection = false
        return table
    } ()

    // MARK: - Other properties
    var presenter: MyNFTPresenterProtocol
    let cellHeight = CGFloat(140)

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
        isNeedToShowPlaceholder()
    }

    // MARK: - IB Action
    @objc private func sortButtonTapped(sender: UIButton) {
        showAlert()
    }

    // MARK: - Private Methods
    private func setupLayout() {
        setupNavigation()
        view.backgroundColor = UIColor.background

        view.addSubViews([myNFTTable])

        NSLayoutConstraint.activate([
            myNFTTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            myNFTTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            myNFTTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            myNFTTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
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

    private func isNeedToShowPlaceholder() {
        let data = presenter.mockArrayOfNFT
        if data.isEmpty {
            showPlaceholder()
        } else {
            myNFTTable.isHidden = false
        }
    }

    private func showPlaceholder() {
        myNFTTable.isHidden = true

        let placeholder = UILabel()
        placeholder.text = "У Вас ещё нет NFT"
        placeholder.font = UIFont.bodyBold
        view.centerView(placeholder)
    }


    private func showAlert() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)
        let priceSorting = UIAlertAction(title: "По цене", style: .default) { _ in }
        let ratingSorting = UIAlertAction(title: "По рейтингу", style: .default) { _ in }
        let nameSorting = UIAlertAction(title: "По названию", style: .default) { _ in }

        alert.addAction(closeAction)
        alert.addAction(priceSorting)
        alert.addAction(ratingSorting)
        alert.addAction(nameSorting)

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyNFTViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTTableViewCell.identifier) as? MyNFTTableViewCell else { return UITableViewCell()}
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }

    private func configureCell(cell: MyNFTTableViewCell, indexPath: IndexPath) {
        let nft = presenter.mockArrayOfNFT[indexPath.row]
        guard let imageName = nft.imageName,
              let author = nft.author else { print("Ooopsss"); return }
        cell.nftImageView.image = UIImage(named: imageName)
        cell.nameView.text = nft.name

        let ratingName = "rating"+"\(nft.rating)"
        let ratingImage = UIImage(named: ratingName)
        cell.ratingImage.image = ratingImage

        cell.authorLabel.text = "от "+"\(author)"
        cell.priceNumberLabel.text = nft.price
    }
}

//MARK: - SwiftUI
import SwiftUI
struct ProviderMy : PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }

    struct ContainterView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return MyNFTViewController(presenter: MyNFTPresenter())
        }

        typealias UIViewControllerType = UIViewController


        let viewController = MyNFTViewController(presenter: MyNFTPresenter())
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProviderMy.ContainterView>) -> MyNFTViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: ProviderMy.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProviderMy.ContainterView>) {

        }
    }
}

