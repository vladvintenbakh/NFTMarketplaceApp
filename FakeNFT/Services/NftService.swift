import Foundation

typealias NftCompletion = (Result<NFTTest, Error>) -> Void
typealias AllNFTsCompletion = (Result<[NFTTest], Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func loadUserNfts(nftIDS: [String], completion: @escaping AllNFTsCompletion)
}

final class NftServiceImpl: NftService {
    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadUserNfts(nftIDS: [String], completion: @escaping AllNFTsCompletion) {
        Task {
            let results = await loadNftsSequentially(ids: nftIDS)

            var loadedNfts: [NFTTest] = []

            for result in results {
                switch result {
                case .success(let nft):
                    loadedNfts.append(nft)
                case .failure(let error):
                    completion(.failure(error))
                }
            }

            if loadedNfts.count == nftIDS.count {
                completion(.success(loadedNfts))
            }
        }
    }

    func loadNftsSequentially(ids: [String]) async -> [Result<NFTTest, Error>] {
        var results: [Result<NFTTest, Error>] = []

        for id in ids {
            let result = await withCheckedContinuation { continuation in
                loadNft(id: id) { result in
                    continuation.resume(returning: result)
                }
            }
            results.append(result)
        }

        return results
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: NFTTest.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
