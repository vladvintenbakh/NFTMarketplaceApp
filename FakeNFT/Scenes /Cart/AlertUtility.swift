//
//  AlertUtility.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 23/5/24.
//

import UIKit

final class AlertUtility {
    static func cartMainScreenSortAlert(
        priceSortCompletion: @escaping () -> (),
        ratingSortCompletion: @escaping () -> (),
        nameSortCompletion: @escaping () -> ()
    ) -> UIAlertController {
        let alert = UIAlertController(title: "Сортировка",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let byPriceAction = UIAlertAction(title: "По цене", style: .default) { _ in
            priceSortCompletion()
        }
        
        let byRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            ratingSortCompletion()
        }
        
        let byNameAction = UIAlertAction(title: "По названию", style: .default) { _ in
            nameSortCompletion()
        }
        
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        [byPriceAction, byRatingAction, byNameAction, closeAction].forEach { item in
            alert.addAction(item)
        }
        
        return alert
    }
    
    static func paymentErrorAlert(retryCompletion: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: "Не удалось произвести оплату",
                                      message: nil,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            retryCompletion()
        }
        
        [cancelAction, retryAction].forEach { action in alert.addAction(action) }
        
        return alert
    }
}
