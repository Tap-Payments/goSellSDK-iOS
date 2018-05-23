//
//  AmountedCurrency.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Structure holding currency and the amount.
internal struct AmountedCurrency: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let currency: Currency
    internal let amount: Decimal
    
    // MARK: Methods
    
    internal init(_ currency: Currency, _ amount: Decimal) {
        
        self.currency = currency
        self.amount = amount
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case currency   = "currency"
        case amount     = "amount"
    }
}

// MARK: - Equatable
extension AmountedCurrency: Equatable {
    
    internal static func == (lhs: AmountedCurrency, rhs: AmountedCurrency) -> Bool {
        
        return lhs.currency == rhs.currency && lhs.amount == rhs.amount
    }
}
