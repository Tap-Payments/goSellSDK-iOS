//
//  AmountedCurrency+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension AmountedCurrency {
    
    internal var displayValue: String {
        
        return CurrencyFormatter.shared.format(self)
    }
    
    internal var readableCurrencyName: String {
        
        let locale = Locale(identifier: goSellSDK.localeIdentifier)
        return locale.localizedString(forCurrencyCode: self.currency.isoCode) ?? self.currency.isoCode
    }
}
