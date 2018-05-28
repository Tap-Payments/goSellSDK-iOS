//
//  PaymentOption.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

/// Payment Option model.
internal struct PaymentOption: Decodable, Identifiable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Unique identifier for the object.
    internal private(set) var identifier: String?
    
    /// Name of the payment option.
    internal private(set) var name: CardBrand
    
    /// Image URL of the payment option.
    internal private(set) var imageURL: URL
    
    /// Payment type.
    internal private(set) var paymentType: PaymentType
    
    /// Supported card brands.
    internal private(set) var supportedCardBrands: [CardBrand]
    
    /// Extra fees.
    internal private(set) var extraFees: [ExtraFee]
    
    /// List of supported currencies.
    internal private(set) var supportedCurrencies: [Currency]
    
    /// Ordering parameter.
    internal private(set) var orderBy: Int
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier             = "id"
        case name                   = "name"
        case imageURL               = "image"
        case paymentType            = "payment_type"
        case supportedCardBrands    = "supported_card_brands"
        case extraFees              = "extra_fees"
        case supportedCurrencies    = "supported_currencies"
        case orderBy                = "order_by"
    }
}
