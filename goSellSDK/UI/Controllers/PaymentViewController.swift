//
//  PaymentViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapVisualEffectView.TapVisualEffectView
import class UIKit.UIViewController.UIViewController

internal class PaymentViewController: UIViewController {
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var blurredBackgroundView: TapVisualEffectView?
    
    @IBOutlet private weak var blurredPayButtonBackgroundView: TapVisualEffectView? {
        
        didSet {
            
            self.blurredPayButtonBackgroundView?.style = .light
        }
    }
    
    // MARK: Methods
    
    @IBAction private func closeButtonTouchUpInside(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            let presentingController = self.presentingViewController
            self.dismiss(animated: true) {
                
                presentingController?.dismiss(animated: false)
            }
        }
    }
}
