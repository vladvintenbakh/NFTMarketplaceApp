//
//  LikesPutRequest.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 04.06.24.
//

import Foundation

struct PutLikesRequest: NetworkRequest {
  // MARK: - Properties:
  var httpMethod: HttpMethod = .put
  var dto: Encodable?
  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
  }
  // MARK: - Methods:
  init(nfts: [String]) {
    let queryString = nfts.map { "likes=\($0)" }.joined(separator: "&")
    self.dto = queryString
  }
}
