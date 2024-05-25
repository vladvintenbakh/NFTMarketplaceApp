//
//  CartMainPresenter.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

protocol CartMainPresenterProtocol {
    
}

final class CartMainPresenter {
    weak private var view: CartMainVC?
    
    private var cartItems: [CartItem] = [
        CartItem(id: "1", nftName: "April", imageName: "MockNFTCard1", rating: 1, price: 1.78),
        CartItem(id: "2", nftName: "Greena", imageName: "MockNFTCard2", rating: 3, price: 1.78),
        CartItem(id: "3", nftName: "Spring", imageName: "MockNFTCard3", rating: 5, price: 1.78),
    ]
    
    func attachView(_ view: CartMainVC) {
        self.view = view
    }
    
    func viewWillAppear() {
        view?.toggleEmptyPlaceholderTo(cartItems.isEmpty)
        view?.updateTotals()
    }
    
    func isCartEmpty() -> Bool {
        return cartItems.isEmpty
    }
    
    func numberOfCartItems() -> Int {
        return cartItems.count
    }
    
    func cartTotalPrice() -> Double {
        var totalPrice = 0.0
        for cartItem in cartItems {
            totalPrice += cartItem.price
        }
        return totalPrice
    }
    
    func configCell(_ cell: CartMainTableViewCell, at indexPath: IndexPath) -> CartMainTableViewCell {
        cell.configUI(cartItem: cartItems[indexPath.row])
        return cell
    }
}
