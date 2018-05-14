//
//  PaymentDataManager+Currency.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension PaymentDataManager {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var currencyCellViewModel: CurrencySelectionTableViewCellViewModel {
        
        guard let result = (self.allPaymentOptionCellViewModels.first { $0 is CurrencySelectionTableViewCellViewModel }) as? CurrencySelectionTableViewCellViewModel else {
            
            fatalError("Payment data manager is corrupted.")
        }
        
        return result
    }
    
    // MARK: Methods
    
    internal func prepareCurrencySelectionController(_ controller: CurrencySelectionViewController) {
        
        controller.delegate = self
        
        let supportedCurrencies = self.supportedCurrencies
        controller.setCurrencies(supportedCurrencies, preselectedCurrency: self.currencyCellViewModel.userSelectedCurrency)
    }
}

// MARK: - CurrencySelectionViewControllerDelegate
extension PaymentDataManager: CurrencySelectionViewControllerDelegate {
    
    internal func currencySelectionViewControllerDidFinish(with currency: AmountedCurrency, changed: Bool) {
        
        self.currencyCellViewModel.userSelectedCurrency = currency
        self.userSelectedCurrency = currency
    }
}
