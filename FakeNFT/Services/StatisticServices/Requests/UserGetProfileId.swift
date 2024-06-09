//
//  UserGetProfileId.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 04.06.24.
//

import Foundation

struct ProfileByIdRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/profile/\(id)")
    }
}
