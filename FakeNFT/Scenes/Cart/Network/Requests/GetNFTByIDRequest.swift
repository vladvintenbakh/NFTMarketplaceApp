//
//  GetNFTByIDRequest.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 2/6/24.
//

import Foundation

struct GetNFTByIDRequest: NetworkRequest {
    private let id: String
    
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/nft/" + id)
    }
    
    init(id: String) {
        self.id = id
    }
}
