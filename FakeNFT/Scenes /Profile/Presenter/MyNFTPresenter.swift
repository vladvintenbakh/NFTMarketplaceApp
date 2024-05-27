//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol MyNFTPresenterProtocol {
    func getNumberOfRows() -> Int
    func getNFT(with indexPath: IndexPath) -> NFTModel
    func isArrayOfNFTEmpty() -> Bool 
    func priceSorting()
    func ratingSorting()
    func nameSorting()
}

final class MyNFTPresenter: MyNFTPresenterProtocol {

    weak var view: MyNFTViewProtocol?

    var mockArrayOfNFT = [NFTModel]()

    init(view: MyNFTViewProtocol?) {
        self.view = view
        mockArrayOfNFT = [mockNFT1, mockNFT2, mockNFT3]
    }


    let mockNFT1 = NFTModel(imageName: "MockNFTCard1", name: "Lilo", rating: 1, author: "John Doe", price: "1.78")
    let mockNFT2 = NFTModel(imageName: "MockNFTCard2", name: "Spring", rating: 2, author: "John Doe", price: "4.12")
    let mockNFT3 = NFTModel(imageName: "MockNFTCard3", name: "April", rating: 4, author: "John Doe", price: "12.99")




    func isArrayOfNFTEmpty() -> Bool {
        return mockArrayOfNFT.isEmpty
    }

    func getNumberOfRows() -> Int {
        return mockArrayOfNFT.count
    }

    func getNFT(with indexPath: IndexPath) -> NFTModel {
        let nft = mockArrayOfNFT[indexPath.row]
        return nft
    }

    func priceSorting() {
        mockArrayOfNFT.sort {
            guard let priceString1 = $0.price,
                  let priceString2 = $1.price,
                  let priceDouble1 = Double(priceString1),
                  let priceDouble2 = Double(priceString2) else { print("Sorting problem"); return false}
            return priceDouble1 > priceDouble2
        }
    }

    func ratingSorting() {
        mockArrayOfNFT.sort {
            guard let rating1 = $0.rating,
                  let rating2 = $1.rating else { print("Sorting problem"); return false}
            return rating1 > rating2
        }
    }

    func nameSorting() {
        mockArrayOfNFT.sort {
            guard let rating1 = $0.name,
                  let rating2 = $1.name else { print("Sorting problem"); return false}
            return rating1 > rating2
        }
    }
}
