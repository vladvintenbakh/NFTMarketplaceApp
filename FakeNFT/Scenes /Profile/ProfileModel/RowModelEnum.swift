//
//  rowModelEnum.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 30.05.2024.
//

import Foundation

enum RowNamesEnum: String, CaseIterable {
    case myNFTName = "Мои NFT"
    case favNFTName = "Избранные NFT"
    case aboutAuthorName = "О разработчике"

    static func getRowName(indexPath: IndexPath, nftCount: Int, favNFT: Int) -> String {
        switch indexPath.row {
        case 0: return RowNamesEnum.myNFTName.rawValue+" (\(nftCount))"
        case 1: return RowNamesEnum.favNFTName.rawValue+" (\(favNFT))"
        default: return RowNamesEnum.aboutAuthorName.rawValue
        }
    }
}
