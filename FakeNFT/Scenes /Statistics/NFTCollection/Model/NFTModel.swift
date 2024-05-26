//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 26.05.24.
//

import UIKit

protocol NFTModelProtocol: AnyObject {
    func getUserNFTCollection() -> [NFT]
}

struct NFT {
    let nftImg: UIImage
    let name: String
    let likes: Bool
    let raiting: Int
    let price: String
}

final class NFTModel: NFTModelProtocol {
    
    private var nftCollection: [NFT] = [
        NFT(nftImg: UIImage(named: "Archie")!, name: "Archie", likes: false, raiting: 2, price: "1,78 ETH"),
        NFT(nftImg: UIImage(named: "Emma")!, name: "Emma", likes: false, raiting: 2, price: "1,78 ETH"),
        NFT(nftImg: UIImage(named: "Stella")!, name: "Stella", likes: false, raiting: 2, price: "1,78 ETH"),
        NFT(nftImg: UIImage(named: "Toast")!, name: "Toast", likes: false, raiting: 2, price: "1,78 ETH"),
        NFT(nftImg: UIImage(named: "Zeus")!, name: "Zeus", likes: false, raiting: 2, price: "1,78 ETH"),
    ]
    
    func getUserNFTCollection() -> [NFT] {
        nftCollection
    }
}
