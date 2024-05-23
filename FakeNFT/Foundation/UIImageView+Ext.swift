//
//  UIImageView+Ext.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import UIKit

extension UIImageView {

    func round(squareSize: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = squareSize / 2
    }
}
