//
//  Currency+Additions.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   Foundation.NSLocale.Locale
import class    Foundation.NSLocale.NSLocale
import class    goSellSDK.Currency

internal extension Currency {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var localizedSymbol: String {
        
        return (Locale.current as NSLocale).displayName(forKey: .currencySymbol, value: self.isoCode) ?? self.isoCode
    }
}
