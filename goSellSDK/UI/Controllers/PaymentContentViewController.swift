//
//  PaymentContentViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGRect
import struct   TapAdditionsKit.TypeAlias
import class    TapVisualEffectView.TapVisualEffectView
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController

/// Payment Content View Controller.
internal class PaymentContentViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var paymentOptionsContainerFrame: CGRect {
        
        if let frame = self.paymentOptionsContainerView?.frame {
            
            var result = frame
            result.origin.y += 1.0
            result.size.height -= 1.0
            
            return result
        }
        else {
            
            return .zero
        }
    }
    
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
    
    internal func hide(_ completion: @escaping TypeAlias.ArgumentlessClosure) {
        
        DispatchQueue.main.async {
            
            self.view.resignFirstResponder {
                
                let presentingController = self.presentingViewController as? PaymentViewController
                self.dismiss(animated: true) {
                    
                    presentingController?.hide(animated: false, completion: completion)
                }
            }
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var paymentOptionsContainerView: UIView?
    
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
        
        LoadingViewController.destroyInstance()
        
        self.hide {
            
            PaymentDataManager.userDidClosePayment()
        }
    }
}
