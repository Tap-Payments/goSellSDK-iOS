//
//  BINResponse.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// BIN Response model.
@objcMembers public final class BINResponse: NSObject, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Card BIN number.
    public private(set) var binNumber: String?
    
    /// Card issuer bank.
    public private(set) var bank: String?
    
    /// Card brand.
    public private(set) var cardBrand: String?
    
    /// Card type.
    public private(set) var cardType: String?
    
    /// Card category.
    public private(set) var cardCategory: String?
    
    /// Card issuing country.
    public private(set) var country: String?
    
    /// Country code.
    public private(set) var countryCode: String?
    
    /// Website.
    public private(set) var website: String?
    
    /// Phone number.
    public private(set) var phone: String?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case binNumber      = "bin"
        case bank           = "bank"
        case cardBrand      = "card_brand"
        case cardType       = "card_type"
        case cardCategory   = "card_category"
        case country        = "country"
        case countryCode    = "country_code"
        case website        = "website"
        case phone          = "phone"
    }
}
