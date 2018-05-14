//
//  PaymentDataManager+PaymentOptionsSelection.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension PaymentDataManager {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var selectedPaymentOptionCellViewModel: PaymentOptionCellViewModel? {
        
        return self.cellModels(of: PaymentOptionCellViewModel.self).first { $0.isSelected }
    }
    
    // MARK: Methods
    
    internal func deselectAllPaymentOptionsModels(except model: PaymentOptionCellViewModel) {
        
        let paymentOptionsModels = self.cellModels(of: PaymentOptionCellViewModel.self)
        paymentOptionsModels.forEach { $0.isSelected = $0 === model }
        
        self.lastSelectedPaymentOption = model
        
        self.updatePayButtonState()
    }
    
    internal func deselectPaymentOption(_ model: PaymentOptionCellViewModel) {
        
        model.isSelected = false
        self.updatePayButtonState()
    }
    
    internal func restorePaymentOptionSelection() {
        
        if let nonnullLastSelectedPaymentOption = self.lastSelectedPaymentOption {
            
            self.deselectAllPaymentOptionsModels(except: nonnullLastSelectedPaymentOption)
        }
        else {
            
            let paymentOptionsModels = self.cellModels(of: PaymentOptionCellViewModel.self)
            paymentOptionsModels.forEach { $0.isSelected = false }
        }
    }
}
