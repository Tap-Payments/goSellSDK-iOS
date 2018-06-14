//
//  TokenizedCard.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

/// Tokenized card model.
internal struct TokenizedCard: Identifiable, Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal private(set) var identifier: String?
    
    /// Object type.
    internal let object: String
    
    /// Last four digits.
    internal let lastFourDigits: String
    
    /// Expiration month.
    internal let expirationMonth: Int
    
    /// Expiration year.
    internal let expirationYear: Int
    
    /// BIN number.
    internal let binNumber: String
    
    /// Card brand.
    internal let brand: CardBrand
    
    /// Card funding.
    internal let funding: String
    
    /// Cardholder name.
    internal let cardholderName: String
    
    /// Customer identifier.
    internal let customerIdentifier: String?
    
    /// Card fingerprint.
    internal let fingerprint: String
    
    /// Address on card.
    internal private(set) var address: Address?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier         = "id"
        case object             = "object"
        case lastFourDigits     = "last_four"
        case expirationMonth    = "exp_month"
        case expirationYear     = "exp_year"
        case binNumber          = "first_six"
        case brand              = "brand"
        case funding            = "funding"
        case cardholderName     = "name"
        case customerIdentifier = "customer"
        case fingerprint        = "fingerprint"
        case address            = "address"
    }
}
