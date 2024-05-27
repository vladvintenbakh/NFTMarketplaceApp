//
//  Presenter.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 26.05.24.
//

import Foundation

protocol NFTCollectionPresenterProtocol: AnyObject {
    var userNFTCollection: [NFT] { get }
    func viewDidLoad()
}

final class NFTCollectionPresenter: NFTCollectionPresenterProtocol {
    weak var view: NFTCollectionViewProtocol?
    private(set) var userNFTCollection: [NFT] = []

    private let NFTModel: NFTModelProtocol

    init(view: NFTCollectionViewProtocol, model: NFTModelProtocol) {
        self.view = view
        self.NFTModel = model
    }

    func viewDidLoad() {
        userNFTCollection = NFTModel.getUserNFTCollection()
        view?.reloadData()
    }
}

