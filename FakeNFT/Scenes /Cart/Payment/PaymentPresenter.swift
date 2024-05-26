//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit
import SafariServices

final class PaymentPresenter {
    weak private var view: PaymentVC?
    
    private let userAgreementURL = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")
    
    func attachView(_ view: PaymentVC) {
        self.view = view
    }
    
    func loadUserAgreement() {
        guard let userAgreementURL else { return }
        let safariVC = SFSafariViewController(url: userAgreementURL)
        view?.present(safariVC, animated: true)
    }
}
