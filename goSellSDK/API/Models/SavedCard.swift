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
    
    /// Expiration date.
    internal let expiry: ExpirationDate
    
    /// Card brand.
    internal let brand: CardBrand
    
    /// Cardholder name.
    internal let cardholderName: String
    
    /// First six digits of card number.
    internal let firstSixDigits: String
    
    /// Currency.
    internal let currency: Currency
    
    /// Order parameter
    internal let orderBy: Int
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier         = "id"
        case object             = "object"
        case lastFourDigits     = "last_four"
        case expiry             = "expiry"
        case brand              = "brand"
        case cardholderName     = "name"
        case firstSixDigits     = "first_six"
        case currency           = "currency"
        case orderBy            = "order_by"
    }
}

// MARK: - Equatable
extension SavedCard: Equatable {
    
    internal static func == (lhs: SavedCard, rhs: SavedCard) -> Bool {
        
        return lhs.lastFourDigits == rhs.lastFourDigits && lhs.expiry == rhs.expiry && lhs.firstSixDigits == rhs.firstSixDigits
    }
}
