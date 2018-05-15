//
//  PayButtonInternalImplementation.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIStoryboard.UIStoryboard
import class UIKit.UIView.UIView

internal protocol PayButtonInternalImplementation: PayButtonProtocol {
    
    var uiElement: PayButtonUI? { get }
    
    var theme: Theme { get }
}

internal extension PayButtonInternalImplementation {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func payButtonTouchUpInside() {
        
        PaymentDataManager.shared.startOver(with: self)
    }
    
    internal func paymentDataManagerDidStartLoadingPaymentOptions() {
        
        self.uiElement?.startLoader()
    }
    
    internal func paymentDataManagerDidStopLoadingPaymentOptions(with success: Bool) {
        
        self.uiElement?.stopLoader()
        
        guard success else { return }
        
        let controller = self.instantiatePaymentContainerController()
        
        if let selfAsView = self as? UIView & PayButtonProtocol {
            
            controller.payButton = selfAsView
        }
        
        self.delegate?.showPaymentController(controller)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func instantiatePaymentContainerController() -> PaymentViewController {
        
        guard let controller = UIStoryboard.goSellSDKPayment.instantiateInitialViewController() as? PaymentViewController else {
            
            fatalError("Failed to instantiate \(PaymentViewController.self) from storyboard.")
        }
        
        return controller
    }
}
