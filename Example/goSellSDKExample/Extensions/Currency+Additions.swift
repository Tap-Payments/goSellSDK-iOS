//
//  Currency+Additions.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import class    goSellSDK.Currency

internal extension Currency {
    
    // MARK: - Internal -
    // MARK: Properties
    
    var localizedSymbol: String {
        
        return (Locale.current as NSLocale).displayName(forKey: .currencySymbol, value: self.isoCode) ?? self.isoCode
    }
}
