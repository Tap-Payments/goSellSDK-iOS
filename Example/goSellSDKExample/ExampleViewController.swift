//
//  ExampleViewController.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class Dispatch.DispatchQueue
import class goSellSDK.PayButton
import protocol goSellSDK.PayButtonDelegate
import class goSellSDK.PaymentContainerViewController
import class UIKit.UIViewController.UIViewController

internal class ExampleViewController: UIViewController {
    
    @IBOutlet private weak var payButton: PayButton? {
        
        didSet {
            
            self.payButton?.delegate = self
        }
    }
}

extension ExampleViewController: PayButtonDelegate {
    
    internal func showPaymentController(_ controller: PaymentContainerViewController) {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.present(controller, animated: false)
        }
    }
}
