//
//  Settings.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class goSellSDK.Currency
import class goSellSDK.CustomerInfo
import class goSellSDK.Shipping
import class goSellSDK.Tax
import enum  goSellSDK.TransactionMode

internal final class Settings: Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static let `default` = Settings(mode: .purchase, currency: try! Currency(isoCode: "kwd"), customer: nil, shippingList: [], taxes: [])
    
    internal var currency: Currency
    
    internal var customer: CustomerInfo? = Serializer.deserialize().first
    
    internal var mode: TransactionMode
    
    internal var shippingList: [Shipping]
    
    internal var taxes: [Tax]
    
    // MARK: Methods
    
    internal init(mode: TransactionMode, currency: Currency, customer: CustomerInfo?, shippingList: [Shipping], taxes: [Tax]) {
        
        self.mode           = mode
        self.currency       = currency
        self.shippingList   = shippingList
        self.taxes          = taxes
    }
}
