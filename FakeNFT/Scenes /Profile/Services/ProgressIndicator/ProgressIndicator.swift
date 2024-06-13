//
//  ProgressIndicator.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 02.06.2024.
//

import UIKit
import ProgressHUD

struct ProgressIndicator {

    static func show() {
        ProgressHUD.colorAnimation = UIColor.yaBlue
        ProgressHUD.show()
    }

    static func succeed() {
        ProgressHUD.colorAnimation = .systemGreen
        ProgressHUD.showSucceed(delay: 0.4)
    }

    static func dismiss() {
        ProgressHUD.dismiss()
    }
}
