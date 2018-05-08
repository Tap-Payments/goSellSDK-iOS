//
//  PaymentDataManager+PaymentOptionsSelection.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension PaymentDataManager {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func deselectAllPaymentOptionsModels(except model: PaymentOptionCellViewModel) {
        
        let paymentOptionsModels = self.cellModels(of: PaymentOptionCellViewModel.self)
        paymentOptionsModels.forEach { $0.isSelected = $0 === model }
    }
    
    internal func removePaymentOptionSelectionIfCellNotVisible() {
        
        guard let selectedOption = self.selectedPaymentOptionCellViewModel else { return }
        
        if !self.paymentOptionCellViewModels.contains { $0 === selectedOption } {
            
            selectedOption.isSelected = false
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var selectedPaymentOptionCellViewModel: PaymentOptionCellViewModel? {
     
        return self.cellModels(of: PaymentOptionCellViewModel.self).first { $0.isSelected }
    }
}
