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
        
        let payButtonEnabled = selectedPaymentViewModel.affectsPayButtonState && selectedPaymentViewModel.isReadyForPayment
        self.makePayButtonEnabled(payButtonEnabled)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func makePayButtonEnabled(_ enabled: Bool) {
        
        self.payButtonUI?.isEnabled = enabled
    }
}

// MARK: - TapButtonDelegate
extension PaymentDataManager: TapButtonDelegate {
    
    internal func buttonTouchUpInside() {
        
        guard let selectedPaymentViewModel = self.selectedPaymentOptionCellViewModel, selectedPaymentViewModel.isReadyForPayment else { return }
        
        self.startPaymentProcess(with: selectedPaymentViewModel)
    }
    
    internal func securityButtonTouchUpInside() {
        
    }
}
