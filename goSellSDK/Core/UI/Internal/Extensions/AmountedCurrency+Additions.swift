//
//  AmountedCurrency+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal extension AmountedCurrency {
	
	// MARK: - Internal -
	// MARK: Properties
	
    var displayValue: String {
        
        return CurrencyFormatter.shared.format(self)
    }
    
    var readableCurrencyName: String {
        
        let locale = LocalizationManager.shared.selectedLocale
		
		if let currencyName = locale.localizedString(forCurrencyCode: self.currency.isoCode) {
			
			return currencyName.prefix(1).capitalized + currencyName.dropFirst()
		}
		else {
			
			return self.currency.isoCode
		}
    }
}
