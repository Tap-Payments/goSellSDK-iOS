//
//  WebPaymentViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIViewController.UIViewController

internal class WebPaymentViewController: UIViewController {
    
    @IBAction private func closeButtonTouchUpInside(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.dismiss(animated: true)
        }
    }
}
