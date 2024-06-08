//
//  ProfileRequestConstants.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 02.06.2024.
//

import Foundation

struct HTTPHeader {
    struct Field {
        static let accept = "Accept"
        static let contentType = "Content-Type"
        static let tokenHeader = "X-Practicum-Mobile-Token"
    }

    struct Value {
        static let json = "application/json"
        static let formURLEncoded = "application/x-www-form-urlencoded"
        static let token = "232360ee-fcae-41be-af04-73a3cac05157"
    }
}

struct FavoritesPUTRequest {
    var scheme = "https"
    var host = "d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    var path = "/api/v1/profile/1"

    var httpMethod: HttpMethod = .put

    var paramName: URLRequestParamNames = .likes
}

struct nftGETRequestWithID {
    var id: String
    var scheme = "https"
    var host = "d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    
    var path: String {
        "/api/v1/nft/\(id)"
    }

    var httpMethod: HttpMethod = .get
}

struct PersonalDataPUTRequest {
    var scheme = "https"
    var host = "d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    var path = "/api/v1/profile/1"

    var httpMethod: HttpMethod = .put

    var nameParam: URLRequestParamNames = .name
    var descriptionParam: URLRequestParamNames = .description
    var website: URLRequestParamNames = .website
    var avatar: URLRequestParamNames = .avatar
}

struct ProfileRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

enum URLRequestParamNames: String {
    case likes = "likes"
    case name = "name"
    case description = "description"
    case website = "website"
    case avatar = "avatar"
}

enum RequestTypes {

}
