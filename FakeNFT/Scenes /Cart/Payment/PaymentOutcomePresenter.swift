//
//  PaymentOutcomePresenter.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

protocol PaymentOutcomePresenterProtocol {
    func attachView(_ view: PaymentOutcomeVCProtocol)
    func initiateReturnToCatalog()
}

final class PaymentOutcomePresenter {
    weak private var view: PaymentOutcomeVCProtocol?
}

// MARK: PaymentOutcomePresenterProtocol
extension PaymentOutcomePresenter: PaymentOutcomePresenterProtocol {
    func attachView(_ view: PaymentOutcomeVCProtocol) {
        self.view = view
    }
    
    func initiateReturnToCatalog() {
        view?.returnToCatalog()
    }
}
