//
//  PaymentDataManager+PayButton.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension PaymentDataManager {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func linkWith(_ payButton: PayButtonUI) {
        
        self.payButtonUI = payButton
        self.updatePayButtonState()
    }
    
    internal func updatePayButtonState() {
        
        guard let selectedPaymentViewModel = self.selectedPaymentOptionCellViewModel else {
            
            self.makePayButtonEnabled(false)
            return
        }
        
        self.makePayButtonEnabled(selectedPaymentViewModel.isReadyForPayment)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func makePayButtonEnabled(_ enabled: Bool) {
        
        self.payButtonUI?.isEnabled = enabled
    }
}

// MARK: - PayButtonUIDelegate
extension PaymentDataManager: PayButtonUIDelegate {
    
    internal func payButtonTouchUpInside() {
        
    }
    
    internal func securityButtonTouchUpInside() {
        
    }
}
