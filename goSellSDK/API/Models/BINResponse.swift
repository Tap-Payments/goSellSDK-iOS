//
//  BINResponse.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

/// BIN Response model.
internal struct BINResponse: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Defines if address is required
    internal let isAddressRequired: Bool
    
    /// Card issuer bank.
    internal let bank: String
    
    /// Bank logo URL.
    internal let bankLogoURL: URL?
    
    /// Card BIN number.
    internal let binNumber: String
    
    /// Card brand.
    internal let cardBrand: CardBrand?
    
    /// Card issuing country.
    internal let country: Country
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case isAddressRequired  = "address_required"
        case bank               = "bank"
        case bankLogoURL        = "bank_logo"
        case binNumber          = "bin"
        case cardBrand          = "card_brand"
        case country            = "country"
    }
}

// MARK: - Equatable
extension BINResponse: Equatable {
    
    internal static func == (lhs: BINResponse, rhs: BINResponse) -> Bool {
        
        return lhs.binNumber == rhs.binNumber
    }
}
