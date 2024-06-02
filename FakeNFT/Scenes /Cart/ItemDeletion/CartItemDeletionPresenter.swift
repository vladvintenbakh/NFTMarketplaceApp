//
//  CartItemDeletionPresenter.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 26/5/24.
//

import UIKit
import Kingfisher

protocol CartItemDeletionPresenterProtocol {
    func attachView(_ view: CartItemDeletionVCProtocol)
    func fetchCartItemImage()
    func confirmDeletion()
}

protocol CartItemDeletionPresenterDelegate: AnyObject {
    func didConfirmDeletionFor(cartItem: CartItem)
}

final class CartItemDeletionPresenter {
    weak var delegate: CartItemDeletionPresenterDelegate?
    
    private weak var view: CartItemDeletionVCProtocol?
    
    private let cartItem: CartItem
    
    init(delegate: CartItemDeletionPresenterDelegate, cartItem: CartItem) {
        self.delegate = delegate
        self.cartItem = cartItem
    }
}

// MARK: CartItemDeletionPresenterProtocol
extension CartItemDeletionPresenter: CartItemDeletionPresenterProtocol {
    func attachView(_ view: CartItemDeletionVCProtocol) {
        self.view = view
    }
    
    func fetchCartItemImage() {
        guard let cardImageURLString = cartItem.images.first else { return }
        guard let cardImageURL = URL(string: cardImageURLString) else { return }
        
        KingfisherManager.shared.retrieveImage(with: cardImageURL) { [weak self] result in
            switch result {
            case .success(let data):
                let image = data.image
                self?.view?.setCartItemImage(image: image)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func confirmDeletion() {
        delegate?.didConfirmDeletionFor(cartItem: cartItem)
    }
}
