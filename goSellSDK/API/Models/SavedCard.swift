//
//  SavedCard.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

/// Saved Card model.
internal struct SavedCard: Decodable, Identifiable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Identifier.
    internal let identifier: String?
    
    /// Object type.
    internal let object: String
    
    /// Last 4 digits of card number.
    internal let lastFourDigits: String
    
    /// Expiration month.
    internal let expirationMonth: String
    
    /// Expiration year.
    internal let expirationYear: String
    
    /// Card brand.
    internal let brand: CardBrand
    
    /// Cardholder name.
    internal let cardholderName: String
    
    /// BIN number.
    internal let binNumber: String
    
    /// Currency.
    internal let currency: Currency
    
    /// Order parameter
    internal let orderBy: Int
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier         = "id"
        case object             = "object"
        case lastFourDigits     = "last4"
        case expirationMonth    = "exp_month"
        case expirationYear     = "exp_year"
        case brand              = "brand"
        case cardholderName     = "name"
        case binNumber          = "bin"
        case currency           = "currency"
        case orderBy            = "order_by"
    }
}
