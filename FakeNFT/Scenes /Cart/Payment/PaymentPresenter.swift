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
    weak private var view: PaymentVCProtocol?
    
    weak var delegate: PaymentPresenterDelegate?
    
    private var selectedCurrency: PaymentCurrency?
    
    private let currencies = [
        PaymentCurrency(id: "1", imageName: "BitcoinPaymentIcon", currencyName: "Bitcoin", currencyCode: "BTC"),
        PaymentCurrency(id: "2", imageName: "DogecoinPaymentIcon", currencyName: "Dogecoin", currencyCode: "DOGE"),
        PaymentCurrency(id: "3", imageName: "TetherPaymentIcon", currencyName: "Tether", currencyCode: "USDT"),
        PaymentCurrency(id: "4", imageName: "ApeCoinPaymentIcon", currencyName: "Apecoin", currencyCode: "APE"),
        PaymentCurrency(id: "5", imageName: "SolanaPaymentIcon", currencyName: "Solana", currencyCode: "SOL"),
        PaymentCurrency(id: "6", imageName: "EthereumPaymentIcon", currencyName: "Ethereum", currencyCode: "ETH"),
        PaymentCurrency(id: "7", imageName: "CardanoPaymentIcon", currencyName: "Cardano", currencyCode: "ADA"),
        PaymentCurrency(id: "8", imageName: "ShibaInuPaymentIcon", currencyName: "Shiba Inu", currencyCode: "SHIB"),
    ]
    
    private let userAgreementURL = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")
}

// MARK: PaymentPresenterProtocol
extension PaymentPresenter: PaymentPresenterProtocol {
    func attachView(_ view: PaymentVCProtocol) {
        self.view = view
    }
    
    func returnToCartMainScreen() {
        view?.dismissVC()
    }
    
    func processPaymentAttempt() {
        guard let selectedCurrency else { return }
        
        if ["Bitcoin", "Dogecoin"].contains(selectedCurrency.currencyName) {
            let paymentOutcomeVC = PaymentOutcomeVC(presenter: PaymentOutcomePresenter())
            paymentOutcomeVC.modalPresentationStyle = .fullScreen
            view?.presentVC(paymentOutcomeVC)
            delegate?.didPurchaseItems()
        } else {
            let paymentErrorAlert = AlertUtility.paymentErrorAlert { [weak self] in self?.processPaymentAttempt() }
            view?.presentVC(paymentErrorAlert)
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
