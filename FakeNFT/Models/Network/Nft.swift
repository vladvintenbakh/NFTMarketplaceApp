//
//  Nft.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 9/6/24.
//

import Foundation

struct Nft: Decodable {
    let id: String
    let images: [URL]
}
