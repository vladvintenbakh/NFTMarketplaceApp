//
//  SetCurrencyBeforePaymentRequest.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 2/6/24.
//

import Foundation

struct SetCurrencyBeforePaymentRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/orders/1/payment/" + currencyID)
    }
    
    private let currencyID: String
    
    init(currencyID: String) {
        self.currencyID = currencyID
    }
}
