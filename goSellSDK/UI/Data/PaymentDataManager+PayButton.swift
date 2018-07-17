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
        self.updatePayButtonStateAndAmount()
    }
    
    internal func updatePayButtonStateAndAmount() {
        
        self.updatePayButtonAmount()
        
        guard let selectedPaymentViewModel = self.selectedPaymentOptionCellViewModel else {
            
            self.makePayButtonEnabled(false)
            return
        }
        
        let payButtonEnabled = selectedPaymentViewModel.affectsPayButtonState && selectedPaymentViewModel.isReadyForPayment
        self.makePayButtonEnabled(payButtonEnabled)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func updatePayButtonAmount() {
        
        let amountedCurrency = self.userSelectedCurrency ?? self.transactionCurrency
        
        if let paymentOption = self.selectedPaymentOptionCellViewModel?.paymentOption {
        
            let extraFeeAmount = self.extraFeeAmount(from: paymentOption.extraFees, in: amountedCurrency)
            
            let amount = AmountedCurrency(amountedCurrency.currency,
                                          amountedCurrency.amount + extraFeeAmount,
                                          currencySymbol: amountedCurrency.currencySymbol)
            
            self.payButtonUI?.amount = amount
        }
        else {
            
            self.payButtonUI?.amount = amountedCurrency
        }
    }
    
    private func makePayButtonEnabled(_ enabled: Bool) {
        
        self.payButtonUI?.isEnabled = enabled
    }
}

// MARK: - TapButtonDelegate
extension PaymentDataManager: TapButtonDelegate {
    
    internal var canBeHighlighted: Bool {
        
        return !self.isExecutingAPICalls
    }
    
    internal func buttonTouchUpInside() {
        
        guard let selectedPaymentViewModel = self.selectedPaymentOptionCellViewModel, selectedPaymentViewModel.isReadyForPayment, !self.isExecutingAPICalls else { return }
        
        self.startPaymentProcess(with: selectedPaymentViewModel)
    }
    
    internal func securityButtonTouchUpInside() {
        
        self.buttonTouchUpInside()
    }
}
