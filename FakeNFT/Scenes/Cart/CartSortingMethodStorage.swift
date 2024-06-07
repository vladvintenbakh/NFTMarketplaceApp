//
//  CartSortingMethodStorage.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 25/5/24.
//

import Foundation

final class CartSortingMethodStorage {
    private let storageKey = "CartSortingMethod"
    
    var savedSortingMethod: CartSortingMethod? {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: storageKey) {
                return CartSortingMethod(rawValue: rawValue)
            }
            return nil
        }
        set {
            UserDefaults.standard.set(newValue?.rawValue, forKey: storageKey)
        }
    }
}
