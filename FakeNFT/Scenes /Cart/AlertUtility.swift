//
//  AlertUtility.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 23/5/24.
//

import UIKit

final class AlertUtility {
    static func cartMainScreenSortAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Сортировка",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let byPriceAction = UIAlertAction(title: "По цене", style: .default)
        let byRatingAction = UIAlertAction(title: "По рейтингу", style: .default)
        let byNameAction = UIAlertAction(title: "По названию", style: .default)
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        [byPriceAction, byRatingAction, byNameAction, closeAction].forEach { item in
            alert.addAction(item)
        }
        
        return alert
    }
}
