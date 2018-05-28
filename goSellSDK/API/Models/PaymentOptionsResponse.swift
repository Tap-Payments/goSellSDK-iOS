//
//  PaymentOptionsResponse.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment Options Response model.
internal struct PaymentOptionsResponse: Identifiable, Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Object identifier.
    internal private(set) var identifier: String?
    
    /// Object type.
    internal let object: String
    
    /// List of available payment options.
    internal let paymentOptions: [PaymentOption]
    
    /// Transaction currency.
    internal let currency: Currency
    
    /// Amount for different currencies.
    internal let supportedCurrenciesAmounts: [AmountedCurrency]
    
    /// Saved cards.
    internal private(set) var savedCards: [SavedCard]?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier                 = "id"
        case object                     = "object"
        case paymentOptions             = "payment_options"
        case currency                   = "currency_code"
        case supportedCurrenciesAmounts = "supported_currencies"
        case savedCards                 = "cards"
    }
}

//extension PaymentOptionsResponse: Decodable {
//
//    internal init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        self.identifier = try container.decode(String.self, forKey: .identifier)
//        self.object = try container.decode(String.self, forKey: .object)
//        self.paymentOptions = try container.decode([PaymentOption].self, forKey: .paymentOptions)
//        self.currency = try container.decode(Currency.self, forKey: .currency)
//        self.cards = (try? container.decode([SavedCard].self, forKey: .cards)) ?? []
//
//        let amounts = try container.decode([String: Decimal].self, forKey: .supportedCurrenciesAmounts)
//        self.supportedCurrenciesAmounts = try amounts.map { AmountedCurrency(try Currency(isoCode: $0.key), $0.value) }
//    }
//}
