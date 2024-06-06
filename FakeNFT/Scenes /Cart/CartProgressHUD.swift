//
//  CartProgressHUD.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 2/6/24.
//

import UIKit
import ProgressHUD

final class CartProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
