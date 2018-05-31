//
//  Card.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Card model.
@objcMembers public final class Card: NSObject, Decodable, Identifiable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Unique identifier for the object.
    public private(set) var identifier: String?
    
    /// String representing the object’s type. Objects of the same type share the same value.
    /// default: card
    public private(set) var object: String?
    
    /// The last 4 digits of the card.
    public private(set) var lastFourDigits: String?
    
    /// Two digit number representing the card's expiration month.
    public private(set) var expirationMonth: Int = 0
    
    /// Two or four digit number representing the card's expiration year.
    public private(set) var expirationYear: Int = 0
    
    /// Card brand. Can be Visa, American Express, MasterCard, Discover, JCB, Diners Club, or Unknown.
    public private(set) var brand: String?
    
    /// Cardholder name.
    public private(set) var name: String?
    
    /// Address line 1 (Street address/PO Box/Company name).
    public private(set) var addressLine1: String?
    
    /// Billing address country, if provided when creating card.
    public private(set) var addressCountry: String?
    
    /// City/District/Suburb/Town/Village.
    public private(set) var addressCity: String?
    
    /// Phone number.
    public private(set) var phoneNumber: String?
    
    /// Zip or postal code.
    public private(set) var addressZip: String?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier         = "id"
        case object             = "object"
        case lastFourDigits     = "last4"
        case expirationMonth    = "exp_month"
        case expirationYear     = "exp_year"
        case brand              = "brand"
        case name               = "name"
        case addressLine1       = "address_line1"
        case addressCountry     = "address_country"
        case addressCity        = "address_city"
        case phoneNumber        = "phone_number"
        case addressZip         = "address_zip"
    }
}
