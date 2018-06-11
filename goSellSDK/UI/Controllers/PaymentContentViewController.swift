//
//  PaymentContentViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapVisualEffectView.TapVisualEffectView
import class UIKit.UIStoryboardSegue.UIStoryboardSegue
import class UIKit.UIViewController.UIViewController

/// Payment Content View Controller.
internal class PaymentContentViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let merchantHeaderController = segue.destination as? MerchantInformationHeaderViewController {
            
            merchantHeaderController.delegate = self
        }
        else if let paymentOptionsController = segue.destination as? PaymentOptionsViewController {
            
            self.paymentOptionsViewController = paymentOptionsController
        }
    }
    
    internal override func performAdditionalAnimationsAfterKeyboardLayoutFinished() {
        
        self.paymentOptionsViewController?.performAdditionalAnimationsAfterKeyboardLayoutFinished()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var payButtonUI: PayButtonUI? {
        
        didSet {
            
            if let nonnullPayButton = self.payButtonUI {
                
                PaymentDataManager.shared.linkWith(nonnullPayButton)
            }
        }
    }
    
    private weak var paymentOptionsViewController: PaymentOptionsViewController?
}

// MARK: - MerchantInformationHeaderViewControllerDelegate
extension PaymentContentViewController: MerchantInformationHeaderViewControllerDelegate {
    
    internal func merchantInformationHeaderViewControllerCloseButtonClicked(_ controller: MerchantInformationHeaderViewController) {
        
        DispatchQueue.main.async {
            
            let dismissalClosure = {
                
                let presentingController = self.presentingViewController
                self.dismiss(animated: true) {
                    
                    presentingController?.dismissFromSeparateWindow(false) {
                        
                        PaymentDataManager.userDidClosePayment()
                    }
                }
            }
            
            if let firstResponder = self.view.firstResponder {
                
                firstResponder.resignFirstResponder(dismissalClosure)
            }
            else {
                
                dismissalClosure()
            }
        }
    }
}
