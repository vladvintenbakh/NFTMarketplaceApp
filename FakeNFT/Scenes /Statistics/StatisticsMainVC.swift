//
//  StatisticsMainVC.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 19/5/24.
//

import UIKit

final class StatisticsMainVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // placeholder label - delete later
        let label = UILabel()
        label.text = "Статистика"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
