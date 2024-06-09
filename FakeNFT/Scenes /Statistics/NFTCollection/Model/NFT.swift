//
//  NFT.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 04.06.24.
//

import UIKit

struct NFT {
    let id: String
    let image: [URL]
    let name: String
    let rating: Int
    let price: String
    var isLiked: Bool
    var isOrdered: Bool
}
