//
//  TokenizedCard.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

/// Tokenized card model.
internal struct TokenizedCard: Identifiable {
    
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

// MARK: - Decodable
extension TokenizedCard: Decodable {
    
    internal init(from decoder: Decoder) throws {
        
        let container           = try decoder.container(keyedBy: CodingKeys.self)
    
        self.identifier         = try container.decodeIfPresent             (String.self,       forKey: .identifier)
        self.object             = try container.decode                      (String.self,       forKey: .object)
        self.lastFourDigits     = try container.decode                      (String.self,       forKey: .lastFourDigits)
        self.expirationMonth    = try container.decode                      (Int.self,          forKey: .expirationMonth)
        self.expirationYear     = try container.decode                      (Int.self,          forKey: .expirationYear)
        self.binNumber          = try container.decode                      (String.self,       forKey: .binNumber)
        self.brand              = try container.decode                      (CardBrand.self,    forKey: .brand)
        self.funding            = try container.decode                      (String.self,       forKey: .funding)
        self.cardholderName     = try container.decode                      (String.self,       forKey: .cardholderName)
        self.customerIdentifier = try container.decodeIfPresent             (String.self,       forKey: .customerIdentifier)
        self.fingerprint        = try container.decode                      (String.self,       forKey: .fingerprint)
        self.address            = try container.decodeIfPresentAndNotEmpty  (Address.self,      forKey: .address)
    }
}
