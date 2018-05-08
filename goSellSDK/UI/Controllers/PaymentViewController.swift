//
//  PaymentViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapVisualEffectView.TapVisualEffectView
import class UIKit.UIStoryboardSegue.UIStoryboardSegue
import class UIKit.UIViewController.UIViewController

internal class PaymentViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let merchantHeaderController = segue.destination as? MerchantInformationHeaderViewController {
            
            merchantHeaderController.delegate = self
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
}

// MARK: - MerchantInformationHeaderViewControllerDelegate
extension PaymentViewController: MerchantInformationHeaderViewControllerDelegate {
    
    internal func merchantInformationHeaderViewControllerCloseButtonClicked(_ controller: MerchantInformationHeaderViewController) {
        
        DispatchQueue.main.async {
            
            let dismissalClosure = {
                
                let presentingController = self.presentingViewController
                self.dismiss(animated: true) {
                    
                    presentingController?.dismiss(animated: false)
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
