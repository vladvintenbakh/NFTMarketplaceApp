//
//  CartMainPresenter.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

protocol CartMainPresenterProtocol {
    func attachView(_ view: CartMainVCProtocol)
    func viewWillAppear()
    func displayPaymentVC()
    func createSortAlert() -> UIAlertController
    func numberOfCartItems() -> Int
    func configCell(_ cell: CartMainTableViewCell, at indexPath: IndexPath) -> CartMainTableViewCell
    func displayDeletionConfirmationFor(indexPath: IndexPath)
    func cartTotalPrice() -> Double
    func isCartEmpty() -> Bool
}

final class CartMainPresenter {
    private weak var view: CartMainVCProtocol?
    
    private lazy var cartItems: [CartItem] = []
    
    private let cartNetworkService: CartNetworkServiceProtocol
    private let cartSortingMethodStorage = CartSortingMethodStorage()
    
    init(cartNetworkService: CartNetworkServiceProtocol) {
        self.cartNetworkService = cartNetworkService
    }
    
    private func syncCartItems() {
        let cartItemIDs = cartItems.map { $0.id }
        let updatedCartOrder = CartOrder(nfts: cartItemIDs)
        
        cartNetworkService.syncCartItems(cartOrder: updatedCartOrder) { error in
            if let error {
                print("Error syncing the items")
            }
        }
    }
    
    private func sortBy(_ sortingMethod: CartSortingMethod) {
        switch sortingMethod {
        case .price:
            cartItems.sort { $0.price < $1.price }
        case .rating:
            cartItems.sort { $0.rating < $1.rating }
        case .name:
            cartItems.sort { $0.name < $1.name }
        }
        cartSortingMethodStorage.savedSortingMethod = sortingMethod
        view?.updateTotals()
    }
}

// MARK: CartItemDeletionPresenterDelegate
extension CartMainPresenter: CartItemDeletionPresenterDelegate {
    func didConfirmDeletionFor(cartItem: CartItem) {
        cartItems.removeAll { $0.id == cartItem.id }
        view?.updateTotals()
    }
}

// MARK: PaymentPresenterDelegate
extension CartMainPresenter: PaymentPresenterDelegate {
    func didPurchaseItems() {
        cartItems = []
        view?.updateTotals()
    }
}

// MARK: CartMainPresenterProtocol
extension CartMainPresenter: CartMainPresenterProtocol {
    func attachView(_ view: CartMainVCProtocol) {
        self.view = view
    }
    
    func viewWillAppear() {
        cartNetworkService.getAllCartItems { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let cartItems):
                print("Loaded successfully")
                self.cartItems = cartItems
                
                let sortingMethod = self.cartSortingMethodStorage.savedSortingMethod ?? .name
                if !cartItems.isEmpty { self.sortBy(sortingMethod) }
                
                self.view?.toggleEmptyPlaceholderTo(cartItems.isEmpty)
                self.view?.updateTotals()
            case .failure:
                print("Network error")
            }
        }
    }
    
    func displayPaymentVC() {
        let paymentPresenter = PaymentPresenter()
        paymentPresenter.delegate = self
        
        let paymentVC = PaymentVC(presenter: paymentPresenter)
        let navigationVC = UINavigationController(rootViewController: paymentVC)
        navigationVC.modalPresentationStyle = .fullScreen
        view?.presentVC(navigationVC)
    }
    
    func createSortAlert() -> UIAlertController {
        let alert = AlertUtility.cartMainScreenSortAlert(
            priceSortCompletion: { [weak self] in self?.sortBy(.price) },
            ratingSortCompletion: { [weak self] in self?.sortBy(.rating) },
            nameSortCompletion: { [weak self] in self?.sortBy(.name) }
        )
        return alert
    }
    
    func numberOfCartItems() -> Int {
        return cartItems.count
    }
    
    func configCell(_ cell: CartMainTableViewCell, at indexPath: IndexPath) -> CartMainTableViewCell {
        cell.configUI(cartItem: cartItems[indexPath.row])
        return cell
    }
    
    func displayDeletionConfirmationFor(indexPath: IndexPath) {
        let cartItem = cartItems[indexPath.row]
        let deletionPresenter = CartItemDeletionPresenter(
            delegate: self,
            cartItem: cartItem
        )
        let deletionVC = CartItemDeletionVC(presenter: deletionPresenter)
        deletionVC.modalPresentationStyle = .overFullScreen
        view?.presentVC(deletionVC)
    }
    
    func cartTotalPrice() -> Double {
        var totalPrice = 0.0
        for cartItem in cartItems {
            totalPrice += cartItem.price
        }
        return totalPrice
    }
    
    func isCartEmpty() -> Bool {
        return cartItems.isEmpty
    }
}
