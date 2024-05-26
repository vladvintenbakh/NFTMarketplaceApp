//
//  PaymentOutcomePresenter.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

final class PaymentOutcomePresenter {
    weak private var view: PaymentOutcomeVC?
    
    func attachView(_ view: PaymentOutcomeVC) {
        self.view = view
    }
    
    func initiateReturnToCatalog() {
        view?.returnToCatalog()
    }
}
