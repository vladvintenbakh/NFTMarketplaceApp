//
//  PutOrderRequest.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 2/6/24.
//

import Foundation

struct PutOrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/orders/1")
    }
    
    var httpMethod: HttpMethod { .put }
    
    var dto: Encodable?
    
    init(dto: Encodable) {
        self.dto = dto
    }
}
