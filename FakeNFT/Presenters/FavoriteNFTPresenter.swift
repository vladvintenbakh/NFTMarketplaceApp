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

    weak var view: FavoriteNFTViewController?

    var mockArrayOfNFT: [NFTModel]

    init() {
        let mockNFT1 = NFTModel(imageName: "MockNFTCard1", name: "Lilo", rating: 1, author: "John Doe", price: "1.78")
        let mockNFT2 = NFTModel(imageName: "MockNFTCard2", name: "Spring", rating: 2, author: "John Doe", price: "4.12")
        let mockNFT3 = NFTModel(imageName: "MockNFTCard3", name: "April", rating: 4, author: "John Doe", price: "12.99")

        mockArrayOfNFT = [mockNFT1, mockNFT2, mockNFT3]
    }

    func getNumberOfRows() -> Int {
        return mockArrayOfNFT.count
    }
}
