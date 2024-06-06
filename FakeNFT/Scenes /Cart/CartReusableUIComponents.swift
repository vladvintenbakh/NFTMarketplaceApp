//
//  CartReusableUIComponents.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

final class CartReusableUIComponents {
    static func standardButton(text: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .yaBlackLight
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .bodyBold
        button.titleLabel?.textColor = .yaWhiteLight
        button.layer.cornerRadius = 16
        return button
    }
}
