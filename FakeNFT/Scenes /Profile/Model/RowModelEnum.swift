//
//  rowModelEnum.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 30.05.2024.
//

import Foundation

enum RowNamesEnum: String, CaseIterable {
    case myNFTName
    case favNFTName
    case aboutAuthorName

    static func getRowName(indexPath: IndexPath, nftCount: Int, favNFT: Int) -> String {
        switch indexPath.row {
        case 0: return "\(SGen.myNFT) (\(nftCount))"
        case 1: return "\(SGen.favoritesNFT) (\(favNFT))"
        default: return "\(SGen.aboutAuthor)"
        }
    }
}
