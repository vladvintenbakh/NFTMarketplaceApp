//
//  CartItemDeletionPresenter.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 26/5/24.
//

import UIKit

protocol CartItemDeletionPresenterDelegate: AnyObject {
    func didConfirmDeletionFor(cartItem: CartItem)
}

final class CartItemDeletionPresenter {
    weak var delegate: CartItemDeletionPresenterDelegate?
    
    private let cartItem: CartItem
    
    init(delegate: CartItemDeletionPresenterDelegate, cartItem: CartItem) {
        self.delegate = delegate
        self.cartItem = cartItem
    }
    
    func getCartItemImage() -> UIImage? {
        return UIImage(named: cartItem.imageName)
    }
    
    func confirmDeletion() {
        delegate?.didConfirmDeletionFor(cartItem: cartItem)
    }
}
