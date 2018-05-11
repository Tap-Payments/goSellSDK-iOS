//
//  CardBINResponse.swift
//  goSellSDK
//
//  Created by Dennis Pashkov on 5/11/18.
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Card BIN Response model.
@objcMembers public class CardBINResponse: NSObject, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    public private(set) var binNumber: String?
    
    public private(set) var bank: String?
    
    public private(set) var cardBrand: String?
    
    public private(set) var cardType: String?
    
    public private(set) var cardCategory: String?
    
    public private(set) var country: String?
    
    public private(set) var countryCode: String?
    
    public private(set) var website: String?
    
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
