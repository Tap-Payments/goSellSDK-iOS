//
//  PaymentOption.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

/// Payment Option model.
internal struct PaymentOption: Identifiable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Unique identifier for the object.
    internal private(set) var identifier: String?
    
    /// Payment option card brand.
    internal private(set) var brand: CardBrand
    
    /// Name of the payment option.
    internal private(set) var title: String
    
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
        case title                  = "name"
        case imageURL               = "image"
        case paymentType            = "payment_type"
        case supportedCardBrands    = "supported_card_brands"
        case extraFees              = "extra_fees"
        case supportedCurrencies    = "supported_currencies"
        case orderBy                = "order_by"
    }
}

// MARK: - Decodable
extension PaymentOption: Decodable {

    internal init(from decoder: Decoder) throws {

        let container           = try decoder.container(keyedBy: CodingKeys.self)

        let identifier          = try container.decodeIfPresent (String.self        , forKey: .identifier)
        let brand               = try container.decode          (CardBrand.self     , forKey: .title)
        let title               = try container.decode          (String.self        , forKey: .title)
        let imageURL            = try container.decode          (URL.self           , forKey: .imageURL)
        let paymentType         = try container.decode          (PaymentType.self   , forKey: .paymentType)
        let supportedCardBrands = try container.decode          ([CardBrand].self   , forKey: .supportedCardBrands)
        let extraFees           = try container.decode          ([ExtraFee].self    , forKey: .extraFees)
        let supportedCurrencies = try container.decode          ([Currency].self    , forKey: .supportedCurrencies)
        let orderBy             = try container.decode          (Int.self           , forKey: .orderBy)
        
        self.init(identifier: identifier,
                  brand: brand,
                  title: title,
                  imageURL: imageURL,
                  paymentType: paymentType,
                  supportedCardBrands: supportedCardBrands,
                  extraFees: extraFees,
                  supportedCurrencies: supportedCurrencies,
                  orderBy: orderBy)
    }
}
