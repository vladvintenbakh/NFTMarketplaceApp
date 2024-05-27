//
//  FavoriteNFTPresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol FavoriteNFTPresenterProtocol {
    var mockArrayOfNFT: [NFTModel] { get }

    func getNumberOfRows() -> Int
}

final class FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {

    weak var view: FavoriteNFTViewProtocol?

    var mockArrayOfNFT = [NFTModel]()

    init(view: FavoriteNFTViewProtocol?) {
        self.view = view
        self.convertData()
    }

    func getNumberOfRows() -> Int {
        return mockArrayOfNFT.count
    }

    func convertData() {
        let data = MockDataStorage.mockData
        guard let favoriteNFT = data.favoriteNFT else { print("Jopa"); return }
        mockArrayOfNFT = favoriteNFT
    }
}
