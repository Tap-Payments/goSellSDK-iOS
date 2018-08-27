//
//  SavedCard.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

/// Saved Card model.
@objcMembers public final class SavedCard: NSObject, OptionallyIdentifiableWithString {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Identifier.
    public private(set) var identifier: String?
    
    /// Object type.
    public let object: String
    
    /// First six digits of card number.
    public let firstSixDigits: String
    
    /// Last 4 digits of card number.
    public let lastFourDigits: String
    
    /// Card brand.
    public let brand: CardBrand
    
    // MARK: Methods
    
    public static func == (lhs: SavedCard, rhs: SavedCard) -> Bool {
        
        return lhs.lastFourDigits == rhs.lastFourDigits && lhs.expiry == rhs.expiry && lhs.firstSixDigits == rhs.firstSixDigits
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Expiration date.
    internal let expiry: ExpirationDate?
    
    /// Cardholder name.
    internal let cardholderName: String?
    
    /// Currency.
    internal let currency: Currency?
    
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
    
    // MARK: Methods
    
    private init(identifier: String?, object: String, firstSixDigits: String, lastFourDigits: String, brand: CardBrand, expiry: ExpirationDate?, cardholderName: String?, currency: Currency?, orderBy: Int) {
        
        self.identifier     = identifier
        self.object         = object
        self.firstSixDigits = firstSixDigits
        self.lastFourDigits = lastFourDigits
        self.brand          = brand
        self.expiry         = expiry
        self.cardholderName = cardholderName
        self.currency       = currency
        self.orderBy        = orderBy
        
        super.init()
    }
}

// MARK: - Decodable
extension SavedCard: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier      = try container.decodeIfPresent(String.self,     forKey: .identifier)
        let object          = try container.decode(String.self,     forKey: .object)
        let firstSixDigits  = try container.decode(String.self,     forKey: .firstSixDigits)
        let lastFourDigits  = try container.decode(String.self,     forKey: .lastFourDigits)
        let brand           = try container.decodeIfPresent(CardBrand.self,         forKey: .brand) ?? .unknown
        let expiry          = try container.decodeIfPresent(ExpirationDate.self,    forKey: .expiry)
        let cardholderName  = try container.decodeIfPresent(String.self,            forKey: .cardholderName)
        let currency        = try container.decodeIfPresent(Currency.self,          forKey: .currency)
        let orderBy         = try container.decodeIfPresent(Int.self,               forKey: .orderBy) ?? 0
        
        self.init(identifier:       identifier,
                  object:           object,
                  firstSixDigits:   firstSixDigits,
                  lastFourDigits:   lastFourDigits,
                  brand:            brand,
                  expiry:           expiry,
                  cardholderName:   cardholderName,
                  currency:         currency,
                  orderBy:          orderBy)
    }
}
