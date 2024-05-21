//
//  CartReusableUIComponents.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

final class CartReusableUIComponents {
    static func standardButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .yaBlackLight
        button.titleLabel?.font = .bodyBold
        button.titleLabel?.textColor = .yaWhiteLight
        button.layer.cornerRadius = 16
        return button
    }
}
