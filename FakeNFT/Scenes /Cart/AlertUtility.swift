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
}
