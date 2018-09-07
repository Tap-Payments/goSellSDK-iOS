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

internal final class Settings: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static let `default` = Settings(mode: .purchase, currency: try! Currency(isoCode: "kwd"), customer: nil, shippingList: [], taxes: [])
    
    internal var currency: Currency
    
    internal var customer: CustomerInfo?
    
    internal var mode: TransactionMode
    
    internal var shippingList: [Shipping]
    
    internal var taxes: [Tax]
    
    // MARK: Methods
    
    internal init(mode: TransactionMode, currency: Currency, customer: CustomerInfo?, shippingList: [Shipping], taxes: [Tax]) {
        
        self.mode           = mode
        self.currency       = currency
        self.customer       = customer
        self.shippingList   = shippingList
        self.taxes          = taxes
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case currency       = "currency"
        case customer       = "customer"
        case mode           = "mode"
        case shippingList   = "shippingList"
        case taxes          = "taxes"
    }
}

// MARK: - Decodable
extension Settings: Decodable {
    
    internal convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let currency = try container.decode(Currency.self, forKey: .currency)
        var customer = try container.decodeIfPresent(CustomerInfo.self, forKey: .customer)
        let mode = try container.decode(TransactionMode.self, forKey: .mode)
        let shippingList = try container.decode([Shipping].self, forKey: .shippingList)
        let taxes = try container.decode([Tax].self, forKey: .taxes)
        
        if customer == nil {
            
            let allCustomers: [CustomerInfo] = Serializer.deserialize()
            customer = allCustomers.first
        }
        
        self.init(mode: mode, currency: currency, customer: customer, shippingList: shippingList, taxes: taxes)
    }
}
