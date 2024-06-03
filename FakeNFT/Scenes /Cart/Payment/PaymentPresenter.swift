//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit
import SafariServices

protocol PaymentPresenterProtocol {
    func attachView(_ view: PaymentVCProtocol)
    func loadCurrencies()
    func returnToCartMainScreen()
    func processPaymentAttempt()
    func loadUserAgreement()
    func numberOfCurrencies() -> Int
    func configCell(_ cell: PaymentCollectionViewCell, at indexPath: IndexPath) -> PaymentCollectionViewCell
    func setSelectedCurrency(indexPath: IndexPath)
}

protocol PaymentPresenterDelegate: AnyObject {
    func didPurchaseItems()
}

final class PaymentPresenter {
    private weak var view: PaymentVCProtocol?
    
    weak var delegate: PaymentPresenterDelegate?
    
    private var selectedCurrency: PaymentCurrency?
    
    private lazy var currencies: [PaymentCurrency] = []
    
    private let userAgreementURL = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")
    
    private let cartNetworkService: CartNetworkService
    
    init(cartNetworkService: CartNetworkService) {
        self.cartNetworkService = cartNetworkService
    }
}

// MARK: PaymentPresenterProtocol
extension PaymentPresenter: PaymentPresenterProtocol {
    func attachView(_ view: PaymentVCProtocol) {
        self.view = view
    }
    
    func loadCurrencies() {
        view?.toggleProgressHUDTo(true)
        cartNetworkService.getCurrencies { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.view?.toggleProgressHUDTo(false)
                self?.currencies = currencies
                self?.view?.reloadCurrencyCollection()
            case .failure(let error):
                self?.view?.toggleProgressHUDTo(false)
                print("Error: \(error)")
            }
        }
    }
    
    func returnToCartMainScreen() {
        view?.dismissVC()
    }
    
    func processPaymentAttempt() {
        guard let selectedCurrency else { return }
        view?.toggleProgressHUDTo(true)
        cartNetworkService.payUsingCurrencyWithID(selectedCurrency.id) { [weak self] result in
            switch result {
            case .success(let paymentResponse):
                self?.view?.toggleProgressHUDTo(false)
                if paymentResponse.success {
                    let paymentOutcomeVC = PaymentOutcomeVC(presenter: PaymentOutcomePresenter())
                    paymentOutcomeVC.modalPresentationStyle = .fullScreen
                    self?.view?.presentVC(paymentOutcomeVC)
                    self?.delegate?.didPurchaseItems()
                } else {
                    let paymentErrorAlert = AlertUtility.paymentErrorAlert { [weak self] in
                        self?.processPaymentAttempt()
                    }
                    self?.view?.presentVC(paymentErrorAlert)
                }
            case .failure(let error):
                self?.view?.toggleProgressHUDTo(false)
                print("Error: \(error)")
            }
        }
    }
    
    func loadUserAgreement() {
        guard let userAgreementURL else { return }
        let safariVC = SFSafariViewController(url: userAgreementURL)
        view?.presentVC(safariVC)
    }
    
    func numberOfCurrencies() -> Int {
        return currencies.count
    }
    
    func configCell(_ cell: PaymentCollectionViewCell, at indexPath: IndexPath) -> PaymentCollectionViewCell {
        cell.configUI(currency: currencies[indexPath.row])
        return cell
    }
    
    func setSelectedCurrency(indexPath: IndexPath) {
        selectedCurrency = currencies[indexPath.row]
    }
}
