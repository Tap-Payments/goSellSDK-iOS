//
//  PaymentOptionsRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct PaymentOptionsRequest: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Items to pay for.
    internal let items: [PaymentItem]
    
    /// Items currency.
    internal let currency: Currency
    
    /// Customer (payer).
    internal let customer: CustomerInfo
    
    // MARK: Methods
    
    internal init(items: [PaymentItem], currency: Currency, customer: CustomerInfo) {
        
        self.items = items
        self.currency = currency
        self.customer = customer
        
        self.totalAmount = items.reduce(0.0) { $0 + $1.totalAmount }
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case items = "items"
        case currency = "currency_code"
        case customer = "customer"
        case totalAmount = "total_amount"
    }
    
    // MARK: Properties
    
    private let totalAmount: Decimal
}
