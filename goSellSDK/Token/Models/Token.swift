//
//  Token.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct Foundation.NSDate.Date
import class Foundation.NSObject.NSObject

/// Token model.
@objcMembers public class Token: NSObject, Decodable, Identifiable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Unique identifier for the object.
    public private(set) var identifier: String?
    
    /// String representing the object’s type. Objects of the same type share the same value.
    /// default: token
    public private(set) var object: String?
    
    /// Card used to make the charge.
    public private(set) var card: TokenCard?
    
    /// Type of the token: card
    public private(set) var type: String?
    
    /// Time at which the object was created. Measured in seconds since the Unix epoch.
    public private(set) var creationDate: Date?
    
    /// Client IP address.
    public private(set) var clientIP: String?
    
    /// Live mode.
    public private(set) var isLiveMode: Bool = false
    
    /// Defines if token was used.
    public private(set) var isUsed: Bool = false
    
    /// Pretty printed description of the Token object.
    public override var description: String {
        
        let lines: [String] = [
            
            "Token",
            "identifier:    \(self.identifier?.description ?? "nil")",
            "object:        \(self.object?.description ?? "nil")",
            "card:          \(self.card?.description(with: 19) ?? "nil")",
            "type:          \(self.type?.description ?? "nil")",
            "creation date: \(self.creationDate?.description ?? "nil")",
            "client IP:     \(self.clientIP?.description ?? "nil")",
            "live mode:     \(self.isLiveMode)",
            "used:          \(self.isUsed)"
        ]
        
        return "\n" + lines.joined(separator: "\n\t")
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier     = "id"
        case object         = "object"
        case card           = "card"
        case type           = "type"
        case creationDate   = "created"
        case clientIP       = "client_ip"
        case isLiveMode     = "livemode"
        case isUsed         = "used"
    }
}

// MARK: - TokenCard -

/// Token card.
@objcMembers public class TokenCard: NSObject, Decodable, Identifiable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Unique identifier for the object.
    public private(set) var identifier: String?
    
    /// String representing the object’s type. Objects of the same type share the same value.
    public private(set) var object: String?
    
    /// The last 4 digits of the card.
    public private(set) var lastFourDigits: String?
    
    /// Two digit number representing the card's expiration month.
    public private(set) var expirationMonth: Int = 0
    
    /// Two or four digit number representing the card's expiration year.
    public private(set) var expirationYear: Int = 0
    
    /// Card brand. Can be Visa, American Express, MasterCard, Discover, JCB, Diners Club, or Unknown.
    public private(set) var brand: String?
    
    /// Customer.
    public private(set) var customer: String?
    
    /// Card type
    public private(set) var cardType: String?
    
    /// Card fingerprint.
    public private(set) var fingerprint: String?
    
    /// Address line 1 (Street address/PO Box/Company name).
    public private(set) var addressLine1: String?
    
    /// Address line 2
    public private(set) var addressLine2: String?
    
    /// Billing address country, if provided when creating card.
    public private(set) var addressCountry: String?
    
    /// City/District/Suburb/Town/Village.
    public private(set) var addressCity: String?
    
    /// Zip or postal code.
    public private(set) var addressZip: Int?
    
    /// Pretty printed description of the TokenCard object.
    public override var description: String {
        
        let lines: [String] = [
        
            "Card",
            "identifier:       \(self.identifier?.description ?? "nil")",
            "object:           \(self.object?.description ?? "nil")",
            "last 4 digits:    \(self.lastFourDigits?.description ?? "nil")",
            "expiration month: \(self.expirationMonth)",
            "expiration year:  \(self.expirationYear)",
            "brand:            \(self.brand?.description ?? "nil")",
            "customer:         \(self.customer?.description ?? "nil")",
            "card type:        \(self.cardType?.description ?? "nil")",
            "fingerprint:      \(self.fingerprint?.description ?? "nil")",
            "address country:  \(self.addressCountry?.description ?? "nil")",
            "address city:     \(self.addressCity?.description ?? "nil")",
            "address line 1:   \(self.addressLine1?.description ?? "nil")",
            "address line 2:   \(self.addressLine2?.description ?? "nil")",
            "address zip:      \(self.addressZip?.description ?? "nil")"
        ]
        
        return "\n" + lines.joined(separator: "\n\t")
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier         = "id"
        case object             = "object"
        case lastFourDigits     = "last4"
        case expirationMonth    = "exp_month"
        case expirationYear     = "exp_year"
        case brand              = "brand"
        case cardType           = "funding"
        case customer           = "customer"
        case fingerprint        = "fingerprint"
        case addressLine1       = "address_line1"
        case addressLine2       = "address_line2"
        case addressCountry     = "address_country"
        case addressCity        = "address_city"
        case addressZip         = "address_zip"
    }
}
