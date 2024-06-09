//
//  ProfileNetworkService.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 01.06.2024.
//

import Foundation

final class ProfileNetworkService {

    private let storage = ProfileStorage.shared

    // MARK: - Public methods
    func getProfile() async throws -> ApiModel? {
        guard let profile = try await completeGETProfileRequest(type: ApiModel.self) else { print("123"); return nil}
        return profile
    }

    func getFavNFTFromNetwork() async {
        guard let listOfFav = storage.profile?.favoriteNFT else { return }
        var favNFT = [NFTModel]()

        for nftID in listOfFav {
            let request = nftGETRequestWithID(id: nftID)

            do {
                let data = try await sendNew(request: request, type: NFTModel.self)
                guard let data else { return }
                favNFT.append(data)
            } catch {
                print(error)
            }
        }
        storage.favNFT = favNFT
        print("✅ Favorite NFT successfully saved to storage")
    }

    func getMyNFTFromNetwork() async {
        guard let listOfMyNFT = storage.profile?.nfts else { return }
        var myNFT = [NFTModel]()

        for nftID in listOfMyNFT {
            let request = nftGETRequestWithID(id: nftID)

            do {
                let data = try await sendNew(request: request, type: NFTModel.self)
                guard let data else { return }
                myNFT.append(data)
            } catch {
                print(error)
            }
        }
        storage.myNFT = myNFT
        print("✅ My NFT successfully saved to storage")
    }

    func putLikes(listOfLikes: [String]) async throws {
        let favInString = listOfLikes.isEmpty ? "null" : listOfLikes.joined(separator: ",")

        let urlRequest = createURLRequest(paramValue: favInString)

        try await sendPUTRequest(url: urlRequest)
    }

    func putPersonalData(newPersonalData: EditedDataModel) async throws {

        let urlRequest = createURLRequestPersonal(newPersonalData: newPersonalData)

        try await sendPUTRequest(url: urlRequest)
    }

    // MARK: - Private methods
    private func createURLRequestPersonal(newPersonalData: EditedDataModel) -> URLRequest? {
        let constants = PersonalDataPUTRequest()
        var urlComponents = URLComponents()
        urlComponents.scheme = constants.scheme
        urlComponents.host = constants.host
        urlComponents.path = constants.path

        urlComponents.queryItems = [
            URLQueryItem(name: constants.nameParam.rawValue, value: newPersonalData.name),
            URLQueryItem(name: constants.descriptionParam.rawValue, value: newPersonalData.description),
            URLQueryItem(name: constants.website.rawValue, value: newPersonalData.website),
            URLQueryItem(name: constants.avatar.rawValue, value: newPersonalData.avatar)
        ]

        guard let url = urlComponents.url else {
            print("Failed to create URL"); return nil }

        var request = URLRequest(url: url)
        request.httpMethod = constants.httpMethod.rawValue
        
        let headers: [String: String] = [
            HTTPHeader.Value.json: HTTPHeader.Field.accept,
            HTTPHeader.Value.formURLEncoded: HTTPHeader.Field.contentType,
            HTTPHeader.Value.token: HTTPHeader.Field.tokenHeader
        ]

        headers.forEach { request.addValue($0.key, forHTTPHeaderField: $0.value) }

        return request
    }

    private func sendNew<T: Decodable>(request: nftGETRequestWithID, type: T.Type) async throws -> T? {
        guard let urlRequest = createURLRequestForNFT(request) else {
            print("We've some problems"); return nil }
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }

    private func completeGETProfileRequest<T: Decodable>(type: T.Type) async throws -> T? {
        guard let urlRequest = createURLRequest() else {
            print("We've some problems"); return nil }
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }

    private func sendPUTRequest(url: URLRequest?) async throws {
        guard let urlRequest = url else { print("WrongRequest"); return }

        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        if let httpResponse = response as? HTTPURLResponse,
           200..<300 ~= httpResponse.statusCode {
        } else { throw NetworkClientError.urlSessionError }
    }

    private func createURLRequestForNFT(_ request: nftGETRequestWithID) -> URLRequest? {
        let constants = request
        var urlComponents = URLComponents()
        urlComponents.scheme = constants.scheme
        urlComponents.host = constants.host
        urlComponents.path = constants.path

        guard let url = urlComponents.url else { print("Hmmm"); return nil}

        var request = URLRequest(url: url)
        request.httpMethod = constants.httpMethod.rawValue
        request.addValue(HTTPHeader.Value.formURLEncoded, forHTTPHeaderField:  HTTPHeader.Field.contentType)
        request.addValue(HTTPHeader.Value.token, forHTTPHeaderField: HTTPHeader.Field.tokenHeader)

        return request
    }

    private func createURLRequest() -> URLRequest? {
        let constants = FavoritesPUTRequest()
        var urlComponents = URLComponents()
        urlComponents.scheme = constants.scheme
        urlComponents.host = constants.host
        urlComponents.path = constants.path

        guard let url = urlComponents.url else { print("Hmmm"); return nil}

        var request = URLRequest(url: url)
        request.httpMethod = constants.httpMethod.rawValue
        request.addValue(HTTPHeader.Value.json, forHTTPHeaderField: HTTPHeader.Field.accept)
        request.addValue(HTTPHeader.Value.formURLEncoded, forHTTPHeaderField:  HTTPHeader.Field.contentType)
        request.addValue(HTTPHeader.Value.token, forHTTPHeaderField: HTTPHeader.Field.tokenHeader)

        return request
    }

    private func createURLRequest(paramValue: String) -> URLRequest? {
        let constants = FavoritesPUTRequest()
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
