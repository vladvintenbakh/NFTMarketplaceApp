//
//  GetCurrenciesRequest.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 2/6/24.
//

import Foundation

struct GetCurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/currencies")
    }
}
