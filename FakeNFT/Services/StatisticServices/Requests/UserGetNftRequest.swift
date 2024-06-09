//
//  UserGetNftRequest.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 04.06.24.
//

import Foundation

struct UserNFTsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/nft")
    }
}
