//
//  GetOrder.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 1/6/24.
//

import Foundation

struct GetOrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/orders/1")
    }
}
