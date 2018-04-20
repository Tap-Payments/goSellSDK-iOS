//
//  PayButtonInternalImplementation.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIStoryboard.UIStoryboard

internal protocol PayButtonInternalImplementation: PayButtonProtocol {}

internal extension PayButtonInternalImplementation {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func payButtonTouchUpInside() {
        
        self.loadPaymentOptionsAndShowPaymentController()
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func loadPaymentOptionsAndShowPaymentController() {
        
        let controller = self.instantiatePaymentContainerController()
        controller.payButton = self
        
        self.delegate?.showPaymentController(controller)
    }
    
    private func instantiatePaymentContainerController() -> PaymentContainerViewController {
        
        guard let controller = UIStoryboard.goSellSDKPayment.instantiateInitialViewController() as? PaymentContainerViewController else {
            
            fatalError("Failed to instantiate \(PaymentContainerViewController.self) from storyboard.")
        }
        
        return controller
    }
}
