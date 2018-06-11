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
    
    func updateDisplayedStateAndAmount()
}

internal extension PayButtonInternalImplementation {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func payButtonTouchUpInside() {
        
        PaymentDataManager.shared.start(with: self)
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
        
        controller.showOnSeparateWindow { [unowned controller] (rootController) in
            
            rootController.allowedInterfaceOrientations = .portrait
            rootController.preferredInterfaceOrientation = .portrait
            rootController.canAutorotate = false
            
            rootController.present(controller, animated: false, completion: nil)
        }
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
