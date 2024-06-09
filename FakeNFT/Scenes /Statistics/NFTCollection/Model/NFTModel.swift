//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 26.05.24.
//

import UIKit

protocol NFTModelProtocol: AnyObject {
    func getUserNFTCollection() -> [NFTTest2]
    func saveNfts(nfts: [NFTTest])
    func saveLikesInfo(nftIds: [String])
    func removeFromLiked(nftIds: [String])
    func setLikesInfo(nftIds: [String])
    func setCurrentOrder(nfts: [String])
    func saveCurrentOrderInfo(nfts: [String])
    func removeFromOrder(nft: [String])
    var likedNfts: [String] { get }
    var orderedNfts: [String] { get }
}

final class NFTModel: NFTModelProtocol {
    private var nftsDB: [String: NFTTest2] = [:]

    private(set) var likedNfts: [String] = []

    private(set) var orderedNfts: [String] = []

    func getUserNFTCollection() -> [NFTTest2] {
        updateLikesInNftDB()
        let nfts = Array(nftsDB.values).sorted {
            $0.name > $1.name
        }
        return nfts
    }

    func setCurrentOrder(nfts: [String]) {
        orderedNfts = nfts
        updateOrdersInNftDB()
    }

    func saveCurrentOrderInfo(nfts: [String]) {
        orderedNfts.append(contentsOf: nfts)
        updateOrdersInNftDB()
    }

    func removeFromOrder(nft: [String]) {
        orderedNfts.removeAll {
            nft.contains($0)
        }
        updateOrdersInNftDB()
    }

    func saveNfts(nfts: [NFTTest]) {
        nfts.forEach {
            nftsDB[$0.id] = convert(nftData: $0)
        }
        updateLikesInNftDB()
    }

    func setLikesInfo(nftIds: [String]) {
        likedNfts.removeAll()
        likedNfts = nftIds
        updateLikesInNftDB()
    }

    func saveLikesInfo(nftIds: [String]) {
        likedNfts.append(contentsOf: nftIds)
        updateLikesInNftDB()
    }

    func removeFromLiked(nftIds: [String]) {
        likedNfts.removeAll {
            nftIds.contains($0)
        }
        updateLikesInNftDB()
    }

    func updateLikesInNftDB() {
        let db: [String: NFTTest2] = nftsDB
        db.forEach { id, _ in
            nftsDB[id]?.isLiked = likedNfts.contains(id)
        }
    }

    func updateOrdersInNftDB() {
        let db: [String: NFTTest2] = nftsDB
        db.forEach { id, _ in
            nftsDB[id]?.isOrdered = orderedNfts.contains(id)
        }
    }
}

extension NFTModel {
    func convert(nftData: NFTTest) -> NFTTest2 {
        return NFTTest2(
            id: nftData.id,
            image: nftData.images,
            name: String(nftData.name.split(separator: " ")[0]),
            rating: nftData.rating,
            price: String(nftData.price),
            isLiked: likedNfts.contains(nftData.id),
            isOrdered: orderedNfts.contains(nftData.id)
        )
    }
}

