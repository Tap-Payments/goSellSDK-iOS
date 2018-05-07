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
        
        let allViewModels = self.allPaymentOptionCellViewModels
        let filteredViewModels = allViewModels.filter { $0 is CurrencySelectionTableViewCellViewModel }
        guard let result = filteredViewModels.first as? CurrencySelectionTableViewCellViewModel else {
            
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
    
    internal func currencySelectionViewControllerDidFinish(with currency: AmountedCurrency) {
        
        self.currencyCellViewModel.userSelectedCurrency = currency
        self.userSelectedCurrency = currency
    }
}
