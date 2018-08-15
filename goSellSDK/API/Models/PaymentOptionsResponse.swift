//
//  PaymentOptionsResponse.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment Options Response model.
internal struct PaymentOptionsResponse: IdentifiableWithString, Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Object identifier.
    internal private(set) var identifier: String?
    
    /// Order identifier.
    internal private(set) var orderIdentifier: String
    
    /// Object type.
    internal let object: String
    
    /// List of available payment options.
    internal let paymentOptions: [PaymentOption]
    
    /// Transaction currency.
    internal let currency: Currency
    
    /// Amount for different currencies.
    internal let supportedCurrenciesAmounts: [AmountedCurrency]
    
    /// Saved cards.
    internal var savedCards: [SavedCard]?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier                 = "id"
        case orderIdentifier            = "order_id"
        case object                     = "object"
        case paymentOptions             = "payment_methods"
        case currency                   = "currency"
        case supportedCurrenciesAmounts = "supported_currencies"
        case savedCards                 = "cards"
    }
}
