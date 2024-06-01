//
//  FavoriteNFTPresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol FavoriteNFTPresenterProtocol {
    func viewDidLoad()
    func getNumberOfRows() -> Int
    func removeNFTFromFav(_ nft: NFTModel)
    func getFavNFT(indexPath: IndexPath) -> NFTModel
}

final class FavoriteNFTPresenter {

    // MARK: - ViewController
    weak var view: FavoriteNFTViewProtocol?

    // MARK: - Private properties
    private var arrayOfFavNFT = [NFTModel]()
    private var listOfFavNFT = [String]()
    private let network = DefaultNetworkClient()

    // MARK: - Life cycle
    func viewDidLoad() {
        getArrayOfFavFromStorage()

        uploadFavNFTFromNetwork()
    }

    // MARK: - Private methods
    private func getArrayOfFavFromStorage() {
        guard let profile = ProfileStorage.profile,
              let favoriteNFT = profile.favoriteNFT else { return }
        listOfFavNFT = favoriteNFT
    }

    private func uploadFavNFTFromNetwork() {
        Task {
            for nftID in listOfFavNFT {
                let request = NFTRequest(id: nftID)

                do {
                    let data = try await network.sendNew(request: request, type: NFTModel.self)
                    // print("✅ Favorite NFT uploaded successfully")
                    guard let data else { return }
                    arrayOfFavNFT.append(data)
                } catch {
                    print(error.localizedDescription)
                }
            }
//            print("listOfFavNFT \(listOfFavNFT)")
            // print("arrayOfFavNFT \(arrayOfFavNFT)")
            updateView()
        }
    }

    private func updateView() {
        view?.updateUI()
        showOrHidePlaceholder()
    }

    private func showOrHidePlaceholder() {
        if listOfFavNFT.isEmpty {
            view?.showPlaceholder()
        } else {
            view?.hideCollection()
        }
    }
}

// MARK: - FavoriteNFTPresenterProtocol
extension FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {

    func getFavNFT(indexPath: IndexPath) -> NFTModel {
        return arrayOfFavNFT[indexPath.row]
    }

    func getNumberOfRows() -> Int {
        return arrayOfFavNFT.count
    }

    func removeNFTFromFav(_ nft: NFTModel) {
        listOfFavNFT.removeAll { $0 == nft.id }
        arrayOfFavNFT.removeAll { $0.name == nft.name }
//        print("listOfFavNFT \(listOfFavNFT)")
        putLikes(listOfLikes: listOfFavNFT)

        }

    func putLikes (listOfLikes: [String]) {
        var favInString = listOfLikes.isEmpty ? "null" : listOfLikes.joined(separator: ",")

        guard let urlRequest = createURLRequestPutLikes(paramName: "likes",
                                          paramValue: favInString)
        else { print("WrongRequest"); return }

        Task {
            do {
                let data = try await putLikes(url: urlRequest, type: ApiModel.self)
                updateView()
            } catch {
                print(error)
            }
        }
    }

    func putLikes<T: Decodable>(url: URLRequest, type: T.Type) async throws -> T? {
        
        let (data, response) = try await URLSession.shared.data(for: url)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else { throw NetworkClientError.urlSessionError }
       
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkClientError.parsingError
        }

    }

    func createURLRequestPutLikes(paramName: String, paramValue: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
        urlComponents.path = "/api/v1/profile/1"

        let query = URLQueryItem(name: paramName, value: paramValue)
        urlComponents.queryItems = [query]

        guard let url = urlComponents.url else { print("Hmmm"); return nil}

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")

        return request

    }

}
