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
}
