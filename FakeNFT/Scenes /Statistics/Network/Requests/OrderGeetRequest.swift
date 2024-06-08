//
//  OrderGeetRequest.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 04.06.24.
//

import Foundation

struct GetOrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

