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

internal final class Settings: Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static let `default` = Settings(currency: try! Currency(isoCode: "kwd"), customer: nil, shippingList: [], taxes: [])
    
    internal var currency: Currency
    
    internal var customer: CustomerInfo? = Serializer.deserialize().first
    
    internal var shippingList: [Shipping]
    
    internal var taxes: [Tax]
    
    // MARK: Methods
    
    internal init(currency: Currency, customer: CustomerInfo?, shippingList: [Shipping], taxes: [Tax]) {
        
        self.currency = currency
        self.shippingList = shippingList
        self.taxes = taxes
    }
}
