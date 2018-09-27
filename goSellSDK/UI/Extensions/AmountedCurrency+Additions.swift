//
//  AmountedCurrency+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension AmountedCurrency {
	
	// MARK: - Internal -
	// MARK: Properties
	
    internal var displayValue: String {
        
        return CurrencyFormatter.shared.format(self)
    }
    
    internal var readableCurrencyName: String {
        
        let locale = LocalizationProvider.shared.selectedLocale
		
		if let currencyName = locale.localizedString(forCurrencyCode: self.currency.isoCode) {
			
			return currencyName.prefix(1).capitalized + currencyName.dropFirst()
		}
		else {
			
			return self.currency.isoCode
		}
    }
}
