//
//  PutOrderRequest.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 09.06.24.
//

import Foundation

struct PutOrderReq: NetworkRequest {
  // MARK: - Properties:
  var httpMethod: HttpMethod = .put
  var dto: Encodable?
  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)")
  }
  // MARK: - Methods:
  init(nfts: [String]) {
    let queryString = nfts.map { "nfts=\($0)" }.joined(separator: "&")
    self.dto = queryString
  }
}
