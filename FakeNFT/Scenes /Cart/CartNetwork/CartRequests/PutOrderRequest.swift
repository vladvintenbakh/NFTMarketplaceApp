//
//  PutOrderRequest.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 2/6/24.
//

import Foundation

struct PutOrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/orders/1" + paramsString)
    }
    
    var httpMethod: HttpMethod { .put }
    
    let paramsString: String
    
    init(paramsString: String) {
        self.paramsString = paramsString
    }
}
