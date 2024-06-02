//
//  CartNetworkService.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 1/6/24.
//

import Foundation

protocol CartNetworkServiceProtocol {
    func getAllCartItems(completion: @escaping (Result<[CartItem], Error>) -> ())
    func syncCartItems(cartOrder: CartOrder, completion: @escaping (Error?) -> ())
}

final class CartNetworkService {
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    private func fulfillCompletionFor<T>(result: Result<T, Error>, completion: @escaping (Result<T, Error>) -> ()) {
        switch result {
        case .success(let data):
            DispatchQueue.main.async {
                completion(.success(data))
            }
        case .failure(let error):
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}

// MARK: CartNetworkServiceProtocol
extension CartNetworkService: CartNetworkServiceProtocol {
    private func getNFTByID(_ id: String, completion: @escaping (Result<CartItem, Error>) -> ()) {
        let getNFTByIDRequest = GetNFTByIDRequest(id: id)
        client.send(request: getNFTByIDRequest, type: CartItem.self) { [weak self] result in
            self?.fulfillCompletionFor(result: result, completion: completion)
        }
    }
    
    private func getOrder(completion: @escaping (Result<CartOrder, Error>) -> ()) {
        let getOrderRequest = GetOrderRequest()
        client.send(request: getOrderRequest, type: CartOrder.self) { [weak self] result in
            self?.fulfillCompletionFor(result: result, completion: completion)
        }
    }
    
    private func getNFTObjectsFromIDs(_ cartOrder: CartOrder,
                                      completion: @escaping (Result<[CartItem], Error>) -> ()) {
        var cartItems: [CartItem] = []
        let dispatchGroup = DispatchGroup()
        for cartItemID in cartOrder.nfts {
            dispatchGroup.enter()
            getNFTByID(cartItemID) { result in
                switch result {
                case .success(let cartItem):
                    cartItems.append(cartItem)
                    dispatchGroup.leave()
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(cartItems))
        }
    }
    
    func getAllCartItems(completion: @escaping (Result<[CartItem], Error>) -> ()) {
        getOrder { [weak self] result in
            switch result {
            case .success(let cartItemIDs):
                self?.getNFTObjectsFromIDs(cartItemIDs) { [weak self] result in
                    self?.fulfillCompletionFor(result: result, completion: completion)
                }
            case .failure(let error):
                self?.fulfillCompletionFor(result: .failure(error), completion: completion)
            }
        }
    }
    
    func syncCartItems(cartOrder: CartOrder, completion: @escaping (Error?) -> ()) {
        var paramsString = ""
        if !cartOrder.nfts.isEmpty {
            for nft in cartOrder.nfts {
                if nft == cartOrder.nfts.first {
                    paramsString += "?nfts=\(nft)"
                } else {
                    paramsString += "&nfts=\(nft)"
                }
            }
        }
        
        let putOrderRequest = PutOrderRequest(paramsString: paramsString)
        
        client.send(request: putOrderRequest) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}
