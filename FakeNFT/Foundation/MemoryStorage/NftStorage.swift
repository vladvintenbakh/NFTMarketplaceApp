import Foundation

protocol NftStorage: AnyObject {
    func saveNft(_ nft: NFTTest)
    func getNft(with id: String) -> NFTTest?
}

// Пример простого класса, который сохраняет данные из сети
final class NftStorageImpl: NftStorage {
    private var storage: [String: NFTTest] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: NFTTest) {
        syncQueue.async { [weak self] in
            guard let self else { return }
            self.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> NFTTest? {
        syncQueue.sync {
            storage[id]
        }
    }
}

