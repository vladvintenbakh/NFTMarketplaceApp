//
//  ProfileNetworkService.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 01.06.2024.
//

import Foundation

final class ProfileNetworkService {

    func putLikes(listOfLikes: [String]) async throws {
        let favInString = listOfLikes.isEmpty ? "null" : listOfLikes.joined(separator: ",")

        let urlRequest = createURLRequest(paramValue: favInString)

        try await sendRequest(url: urlRequest)
    }

    func sendNew<T: Decodable>(request: NFTRequest, type: T.Type) async throws -> T? {
        guard  let urlRequest = DefaultNetworkClient().create(request: request) else {
            print("We've some problems"); return nil }
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }

    private func sendRequest(url: URLRequest?) async throws {
        guard let urlRequest = url else { print("WrongRequest"); return }

        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        if let httpResponse = response as? HTTPURLResponse,
           200..<300 ~= httpResponse.statusCode {
            print("✅ listOfFav updated successfully")
        } else { throw NetworkClientError.urlSessionError }
    }

    private func createURLRequest(paramValue: String) -> URLRequest? {
        let constants = ProfilePUTRequest()
        var urlComponents = URLComponents()
        urlComponents.scheme = constants.scheme
        urlComponents.host = constants.host
        urlComponents.path = constants.path

        let query = URLQueryItem(name: constants.paramName.rawValue, value: paramValue)
        urlComponents.queryItems = [query]


        guard let url = urlComponents.url else { print("Hmmm"); return nil}

        var request = URLRequest(url: url)
        request.httpMethod = constants.httpMethod.rawValue
        request.addValue(HTTPHeader.Value.json, forHTTPHeaderField: HTTPHeader.Field.accept)
        request.addValue(HTTPHeader.Value.formURLEncoded, forHTTPHeaderField:  HTTPHeader.Field.contentType)
        request.addValue(HTTPHeader.Value.token, forHTTPHeaderField: HTTPHeader.Field.tokenHeader)

        return request
    }
}