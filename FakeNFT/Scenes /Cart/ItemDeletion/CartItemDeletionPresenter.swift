//
//  CartItemDeletionPresenter.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 26/5/24.
//

import UIKit

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
        view?.setCartItemImage(imageName: cartItem.images[0])
    }
    
    func confirmDeletion() {
        delegate?.didConfirmDeletionFor(cartItem: cartItem)
    }
}
